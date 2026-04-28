::Hardened.HooksMod.hook("scripts/ui/screens/tactical/tactical_combat_result_screen", function(q) {
	// Overwrite, because we change the behavior of the original the following way:
	//	- Vanilla Fix: error when trying to play a sound from an item after its onAddedToStash has made it remove itself
	//	- Feat: Implement optional "Smart Auto Loot" feature
	q.onLootAllItemsButtonPressed = @() function()
	{
		if (::Tactical.CombatResultLoot.isEmpty())
		{
			return ::Const.UI.convertErrorToUIData(::Const.UI.Error.FoundLootListIsEmpty);
		}

		local soundPlayed = false;
		local hasLootScreenChanged = false;

		local currentStashIdx = 0;
		local stashItems = ::Stash.getItems();
		foreach (index, lootItem in ::Tactical.CombatResultLoot.getItems())
		{
			if (lootItem == null) continue;

			// Step 1: If the item is a supply item (= consumable), consume it
			if (lootItem.isConsumed())
			{
				lootItem.consume();
				::Tactical.CombatResultLoot.getItems()[index] = null;
				continue;
			}

			// Step 2: Try to add the item into an empty slot
			local foundEmptySlot = false;
			for (; currentStashIdx < stashItems.len(); ++currentStashIdx)
			{
				if (stashItems[currentStashIdx] != null) continue;
				foundEmptySlot = true;
				hasLootScreenChanged = true;

				this.HD_lootItemToStash(index, currentStashIdx, !soundPlayed);
				soundPlayed = true;
				break;
			}
			if (foundEmptySlot) continue;

			if (::Hardened.Mod.ModSettings.getSetting("EnableSmartAutoLoot").getValue())
			{
				// Step 3: There is no empty space in the stash, so we try to kick out the cheapest item in the stash
				local cheapestStashItem = this.HD_getCheapestStashItem();
				if (this.HD_getLootValue(lootItem) > cheapestStashItem.value)
				{
					hasLootScreenChanged = true;
					this.HD_lootItemToStash(index, cheapestStashItem.idx, !soundPlayed);
					soundPlayed = true;
				}
			}
		}

		::Tactical.CombatResultLoot.shrink();

		if (hasLootScreenChanged)
		{
			return {
				stash = ::UIDataHelper.convertStashToUIData(true),
				foundLoot = ::UIDataHelper.convertCombatResultLootToUIData()
			};
		}
		else
		{
			return ::Const.UI.convertErrorToUIData(::Const.UI.Error.NotEnoughStashSpace);
		}
	}

// New Functions
	// Helper function for swapping two items (given by their indices) between the loot screen and player inventory
	q.HD_lootItemToStash <- function( _lootIndex, _stashIndex, _playSound )
	{
		local lootStash = ::Tactical.CombatResultLoot.getItems();
		local playerStash = ::Stash.getItems();

		local lootedItem = lootStash[_lootIndex];
		local stashItem = playerStash[_stashIndex];

		playerStash[_stashIndex] = lootedItem;
		lootStash[_lootIndex] = stashItem;

		if (_playSound)
		{
			lootedItem.playInventorySound(::Const.Items.InventoryEventType.PlacedInBag);
		}

		// We need to trigger the onAddedToStash event after playing the inventory sound, because this event might cause the item to immediately disappear
		lootedItem.onAddedToStash(::Stash.getID());
	}

	/// Return the index and value of the cheapeast item from the player inventory, which is neither unique nor precious
	/// If the inventory is empty, then this will return the idx = 0 and value = 999999
	q.HD_getCheapestStashItem <- function()
	{
		local ret = {
			value = 999999,
			idx = 0,
		}

		foreach (index, stashItem in ::Stash.getItems())
		{
			if (stashItem == null) continue;

			// We always ignore unique and precious items. Those need to be manually sorted out
			if (stashItem.isUnique()) continue;
			if (stashItem.isPrecious()) continue;

			// We hand-pick ingredients, utility items and consumables to never be automatically dropped from the inventory
			if (stashItem.isItemType(::Const.Items.ItemType.Crafting)) continue;
			if (stashItem.isItemType(::Const.Items.ItemType.Food)) continue;
			if (stashItem.isItemType(::Const.Items.ItemType.Tool)) continue;
			if (stashItem.isItemType(::Const.Items.ItemType.Usable)) continue;

			if (this.HD_getLootValue(stashItem) >= ret.value) continue;

			ret.value = this.HD_getLootValue(stashItem);
			ret.idx = index;
		}

		return ret;
	}

	// Get a value of _item, that is much more comparable with its actual worth to the player
	// This makes certain itemtypes use their buy price as value, when those items are not meant to be sold as loot
	q.HD_getLootValue <- function( _item )
	{
		local valueableItems = ::Const.Items.ItemType.Accessory | ::Const.Items.ItemType.Crafting | ::Const.Items.ItemType.Food | ::Const.Items.ItemType.Loot |  ::Const.Items.ItemType.Tool | Const.Items.ItemType.TradeGood | ::Const.Items.ItemType.Usable;

		if (_item.isItemType(valueableItems))
		{
			return _item.getBuyPrice();
		}
		else
		{
			return _item.getSellPrice();
		}
	}
});
