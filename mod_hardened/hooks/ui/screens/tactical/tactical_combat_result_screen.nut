// This is used to fix an issue with the vanilla onLootAllItemsButtonPressed
// Vanilla first adds an item to your inventory, and afterwards sometimes tries to access that same index again trying to play an inventory sound
// But if my tools/money etc. would vanish instantly here, during autoloot, then the looting would crash, trying to access null
::Hardened.Temp.LootAllItemsButtonPressed <- false;

::Hardened.HooksMod.hook("scripts/ui/screens/tactical/tactical_combat_result_screen", function(q) {
	q.onLootAllItemsButtonPressed = @(__original) function()	// This is called during battle
	{
		::Hardened.Temp.LootAllItemsButtonPressed = true;
		local ret = __original();
		::Hardened.Temp.LootAllItemsButtonPressed = false;
		return ret;
	}

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

			// Step 1: Try to add the item into an empty slot
			for (; currentStashIdx < stashItems.len(); ++currentStashIdx)
			{
				if (stashItems[currentStashIdx] != null) continue;
				hasLootScreenChanged = true;

				this.HD_lootItemToStash(index, currentStashIdx, !soundPlayed);
				soundPlayed = true;
				break;
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
});
