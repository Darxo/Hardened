::Hardened.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.addBusinessReputation = @(__original) function( _f )
	{
		__original(_f);

		if (_f == 0) return;

		local activeScreen = null;
		if(::World.Contracts.getActiveContract() != null)
		{
			activeScreen = ::World.Contracts.getActiveContract().m.ActiveScreen;
		}
		else if(::World.Events.m.ActiveEvent != null)
		{
			activeScreen = ::World.Events.m.ActiveEvent.m.ActiveScreen;
		}

		if (activeScreen != null)
		{
			// We push a notification about the just gained renown into the current contract screen list, so the player has accurate information about it
			activeScreen.List.push({
				id = 30,
				icon = "ui/icons/ambition_tooltip.png",
				text = format("You %s %s Renown", _f > 0 ? "gain" : "lose", ::MSU.Text.colorizeValue(::Math.round(_f))),
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
		foreach (brotherSnapshot in this.m.RestoreEquipment)
		{
			local bro = ::Tactical.getEntityByID(brotherSnapshot.ID);
			if (bro == null || !bro.isAlive()) continue;

			danglingItems.extend(this.unEquipWrongItems(bro, brotherSnapshot));
		}

		foreach (brotherSnapshot in this.m.RestoreEquipment)	// For every snapshot (bro)
		{
			local bro = ::Tactical.getEntityByID(brotherSnapshot.ID);
			if (bro == null || !bro.isAlive()) continue;

			// We look through all entries of this brother and try to restore or replace them, if they are missing
			foreach (entry in brotherSnapshot.Slots)
			{
				if (entry.Item.isEquipped()) continue;	// This item is already at its righteous place

				local foundOriginal = false;

				foreach (index, danglingItem in danglingItems)
				{
					if (!::MSU.isEqual(danglingItem, entry.Item)) continue;

					// The item is among the dangling items
					bro.getItems().HD_equipToSlot(entry.Item, entry.Slot);
					danglingItems.remove(index);
					foundOriginal = true;
					break;
				}
				if (foundOriginal) continue;

				// Maybe it is in our stash after we dropped it during battle and looted it afterwards?
				foreach (stashItem in this.getStash().getItems())
				{
					if (stashItem == null) continue;
					if (!::MSU.isEqual(stashItem, entry.Item)) continue;

					bro.getItems().HD_equipToSlot(entry.Item, entry.Slot);
					this.getStash().remove(stashItem);
					foundOriginal = true;
					break;
				}
				if (foundOriginal) continue;

				// If the original item was found nowhere, then entry.Item does not exist anymore and is only kept alive because of our reference to it
				// Feat: We now try to find a replacement item for it from the player stash, which uses the same ID
				foreach (stashItem in this.getStash().getItems())
				{
					if(stashItem == null) continue;
					if(stashItem.getID() != entry.Item.getID()) continue;

					bro.getItems().HD_equipToSlot(entry.Item, entry.Slot);
					this.getStash().remove(stashItem);
					break;
				}
			}
		}

		foreach (item in danglingItems)	// All dangling items are added to the player stash
		{
			this.getStash().makeEmptySlots(1);	// We always treat dangling items important enough to make room for them
			this.getStash().add(item);
		}

		this.m.RestoreEquipment = [];	// We clear the vanilla array, just like vanilla does it
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
});
