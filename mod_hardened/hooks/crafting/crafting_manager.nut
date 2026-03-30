::Hardened.HooksMod.hookTree("scripts/crafting/crafting_manager", function(q) {
	q.m.HD_MappedPlayerInventory <- {};

	q.getQualifiedBlueprintsForUI = @(__original) function()
	{
		this.HD_mapPlayerInventory();
		local ret = __original();
		this.HD_clearMappedPlayerInventory();

		return ret;
	}

// New Functions
	// Iterate over the player inventory and create a table where the keys are itemIDs and the values are the amount of that item present in that inventory
	q.HD_mapPlayerInventory <- function()
	{
		this.HD_clearMappedPlayerInventory();

		foreach (item in ::World.Assets.getStash().getItems())
		{
			if (item == null) continue;

			if (item.getID() in this.m.HD_MappedPlayerInventory)
			{
				this.m.HD_MappedPlayerInventory[item.getID()] += 1;
			}
			else
			{
				this.m.HD_MappedPlayerInventory[item.getID()] <- 1;
			}
		}
	}

	// Return whether the player inventory has enough items with the id _itemID to meet the required amount _targetedAmount
	q.HD_hasItemAmount <- function( _itemID, _targetedAmount )
	{
		// We can't guarantee that the player inventory is mapped when this function is called,
		// so as a fall-back, we use the vanilla approach, if this map is not generated
		if (this.m.HD_MappedPlayerInventory.len() != 0)
		{
			// If we have mapped the player inventory, then we can now ask that map whether there are enough items available
			// This is much faster than the vanilla approach
			if (_itemID in this.m.HD_MappedPlayerInventory)
			{
				return this.m.HD_MappedPlayerInventory[_itemID] >= _targetedAmount;
			}
		}
		else
		{
			// Same method as to how vanilla verifies the ingredients
			local num = 0;
			foreach (item in ::World.Assets.getStash().getItems())
			{
				if (item == null) continue;
				if (item.getID() != _itemID) continue;

				++num;
				if (num >= _targetedAmount)
				{
					return true;
				}
			}
		}

		return false;
	}

	q.HD_clearMappedPlayerInventory <- function()
	{
		this.m.HD_MappedPlayerInventory.clear();
	}
});
