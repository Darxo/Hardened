::Hardened.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.addBusinessReputation = @(__original) function( _f )
	{
		__original(_f);

		if (_f == 0) return;

		local activeObject = null;
		if (::World.Contracts.m.IsEventVisible && !::MSU.isNull(::World.Contracts.m.LastShown) && !::MSU.isNull(::World.Contracts.m.LastShown.getActiveScreen()))		// Contracts and Negotiations
		{
			activeObject = ::World.Contracts.m.LastShown;
		}
		else if (::World.Events.m.ActiveEvent != null)		// Regular Events
		{
			activeObject = ::World.Events.m.ActiveEvent;
		}
		else if (!::MSU.isNull(::World.Contracts.getActiveContract()) && ::World.Contracts.getActiveContract().m.HD_CalledPrematureSetScreen)
		{
			// We gained Renown while a screen was set but the contract wasnt yet shown to the player
			activeObject = ::World.Contracts.getActiveContract();
		}

		if (activeObject != null)
		{
			// We push a notification about the just gained renown into the current contract screen list, so the player has accurate information about it
			activeObject.addListItem({
				id = 30,
				icon = "ui/icons/ambition_tooltip.png",
				text = format("You %s %s Renown", _f > 0 ? "gain" : "lose", ::MSU.Text.colorizeValue(_f, {HD_UseEventColors = true})),
			});
		}
	}

	q.checkDesertion = @(__original) function()
	{
		__original();
		if (!::World.Events.canFireEvent()) return;

		local event = ::World.Events.getEvent("event.retinue_slot");
		local unlockedSlots = ::World.Retinue.getNumberOfUnlockedSlots();
		if (unlockedSlots > event.m.LastSlotsUnlocked && ::World.Retinue.getNumberOfCurrentFollowers() < unlockedSlots)
		{
			::World.Events.fire("event.retinue_slot", false);
		}
	}

	q.getMoralReputationAsText = @(__original) function()
	{
		local ret = __original();

		if (::Hardened.Mod.ModSettings.getSetting("DisplayMoraleValue").getValue())
		{
			ret += " (" + this.m.MoralReputation + ")";
		}

		return ret;
	}

	q.getBusinessReputationAsText = @(__original) function()
	{
		local ret = __original();

		if (::Hardened.Mod.ModSettings.getSetting("AlwaysDisplayRenownValue").getValue())
		{
			ret += " (" + this.m.BusinessReputation + ")";
		}

		return ret;
	}

	// Overwrite, because we rewrite the original function a bit cleaner and with more recovery functionality
	q.restoreEquipment = @() function()
	{
		local danglingItems = [];	// First we need to collect and unequip all dangling items, which were wrongly equipped
		for (local i = this.m.RestoreEquipment.len() - 1; i >= 0; --i)
		{
			local brotherSnapshot = this.m.RestoreEquipment[i];
			local bro = ::Tactical.getEntityByID(brotherSnapshot.ID);
			if (bro == null || !bro.isAlive())
			{
				this.m.RestoreEquipment.remove(i);	// This snapshot belongs to a brother who died or is otherwise no longer existing, so there is nothing to restore
			}
			else
			{
				// We unequip that brothers current items and push those into danglingItems array
				danglingItems.extend(this.unEquipWrongItems(bro, brotherSnapshot));
			}
		}

		local orphanedSnapshots = [];
		foreach (brotherSnapshot in this.m.RestoreEquipment)	// For every snapshot (bro)
		{
			local bro = ::Tactical.getEntityByID(brotherSnapshot.ID);

			// We look through all entries of this brother and try to restore or replace them, if they are missing
			for (local i = brotherSnapshot.Slots.len() - 1; i >= 0; --i)
			{
				local entry = brotherSnapshot.Slots[i];
				if (bro.getItems().HD_isEquippedIn(entry.Item, entry.Slot)) continue;	// This item is already at its righteous place

				// Now we first try to locate the original item:
				local foundOriginal = false;
				for (local j = danglingItems.len() - 1; j >= 0; --j)	// Maybe it's in the unequipped itempool from our allies?
				{
					local danglingItem = danglingItems[j];
					if (!this.HD_isEqualAndEquippable(danglingItem, entry)) continue;

					// The item is among the dangling items
					bro.getItems().HD_equipToSlot(danglingItem, entry.Slot);
					brotherSnapshot.Slots.remove(i);
					danglingItems.remove(j);
					foundOriginal = true;
					break;
				}
				if (foundOriginal) continue;

				local stashItems = this.getStash().getItems();
				for (local j = stashItems.len() - 1; j >= 0; --j)	// Maybe it is in our stash after we dropped it during battle and looted it afterwards?
				{
					local stashItem = stashItems[j];
					if (stashItem == null) continue;
					if (!this.HD_isEqualAndEquippable(stashItem, entry)) continue;

					bro.getItems().HD_equipToSlot(stashItem, entry.Slot);
					brotherSnapshot.Slots.remove(i);
					this.getStash().removeByIndex(j);	// RemoveByIndex is much faster than by reference
					foundOriginal = true;
					break;
				}
				if (foundOriginal) continue;

				// We couldn't locate the original
				local foundReplacement = false;
				// Feat: We now try to find a replacement item for it from the player stash, which uses the same ID
				for (local j = stashItems.len() - 1; j >= 0; --j)
				{
					local stashItem = stashItems[j];
					if (stashItem == null) continue;
					if (!this.HD_isReplacement(stashItem, entry)) continue

					// We found a replacement item in the stash!
					bro.getItems().HD_equipToSlot(stashItem, entry.Slot);
					brotherSnapshot.Slots.remove(i);
					this.getStash().removeByIndex(j);	// RemoveByIndex is much faster than by reference
					foundReplacement = true;
					break;
				}
				if (foundReplacement) continue;

				// We couldn't yet satisfy this snapshot
				orphanedSnapshots.push(brotherSnapshot);
			}
		}

		// Last we try to find a replacement from the dangling items (ours and those of allies), before those are flushed into the stash
		// orphanedSnapshots only contains brotherSnapshots for still missing items and only slot entries for those yet still missing items
		foreach (brotherSnapshot in orphanedSnapshots)
		{
			local bro = ::Tactical.getEntityByID(brotherSnapshot.ID);
			// We look through all entries of this brother and try to find replacemants, if they are missing
			foreach (entry in brotherSnapshot.Slots)
			{
				for (local i = danglingItems.len() - 1; i >= 0; --i)
				{
					local danglingItem = danglingItems[i];
					if (!this.HD_isReplacement(danglingItem, entry)) continue

					// The item is among the dangling items
					bro.getItems().HD_equipToSlot(danglingItem, entry.Slot);
					danglingItems.remove(i);
					break;
				}
			}
		}

		// All other dangling items (e.g. picked up from the ground) are added to the player stash
		foreach (item in danglingItems)
		{
			this.getStash().makeEmptySlots(1);	// We always treat dangling items important enough to make room for them
			this.getStash().add(item);
		}

		this.m.RestoreEquipment = [];	// We clear the array, just like vanilla does it
	}

// New Functions
	// Unequip all items equipped to or in the bag of _bro, which are not mentioned in _restorePoint and return them
	// @return array of item references of all "wrong" items unequipped this way
	q.unEquipWrongItems <- function( _bro, _restorePoint )
	{
		local danglingItems = [];	// Array of dangling items, that didn't belong equipped to this character

		foreach (itemSlot, _ in ::Const.ItemSlotSpaces)
		{
			foreach (item in _bro.getItems().getAllItemsAtSlot(itemSlot))
			{
				local isAllowedToStay = false;
				foreach (slot in _restorePoint.Slots)	// Is that item covered by any of our restorePoint slots?
				{
					if (slot.Slot != itemSlot) continue;
					if (!::MSU.isEqual(slot.Item, item)) continue;

					isAllowedToStay = true;
					break;
				}
				if (isAllowedToStay) continue;

				danglingItems.push(item);
				if (itemSlot == ::Const.ItemSlot.Bag)
				{
					_bro.getItems().removeFromBag(item);
				}
				else
				{
					_bro.getItems().unequip(item);
				}
			}
		}

		return danglingItems;
	}

	// Check, if _item is "equal enough" to the information given in _slotSnapshot
	// This is similar to ::MSU.isEqual of _item and _slotSnapshot.Item, except that we also make sure that the item is still equippable into that given slot
	// Shields are an example of items that are no longer equippable, when their condition reaches 0
	q.HD_isEqualAndEquippable <- function( _item, _slotSnapshot )
	{
		if (::MSU.isEqual(_item, _slotSnapshot.Item))
		{
			// If the item was in the bag before, then we can move it there again
			if (_slotSnapshot.Slot == ::Const.ItemSlot.Bag) return true;

			if (_item.getSlotType() == _slotSnapshot.Slot) return true;
			// If the item default slot no longer matches the slot it was in before, then we dont consider it equal
		}

		return false;
	}

	// Check, if _item is "similar enough" to the information given in _slotSnapshot
	// This is similar to comparing the ID of _item and _slotSnapshot.Item, except that we also make sure that the item is still equippable into that given slot
	// Shields are an example of items that are no longer equippable, when their condition reaches 0
	q.HD_isReplacement <- function( _item, _slotSnapshot )
	{
		if (_item.getID() == _slotSnapshot.Item.getID())
		{
			// If the item was in the bag before, then we can move it there again
			if (_slotSnapshot.Slot == ::Const.ItemSlot.Bag) return true;

			// If the item default slot doesnt matches the slot taht we seek, then we dont consider it a replacement
			if (_item.getSlotType() == _slotSnapshot.Slot) return true;
		}

		return false;
	}
});
