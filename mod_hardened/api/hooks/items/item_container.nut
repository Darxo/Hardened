::Hardened.HooksMod.hook("scripts/items/item_container", function(q) {
// New Functions
	// Helper function to equip an item, if we know which slot it belongs to. This is used during restoreEquipment
	// @param _slot is only used to determine, whether we should put the item into the bag,
	//		otherwise it's default equipped and chooses its target slot itself
	q.HD_equipToSlot <- function( _item, _slot )
	{
		if (_slot == ::Const.ItemSlot.Bag)
		{
			this.addToBag(_item);
		}
		else
		{
			this.equip(_item);
		}
	}

// New Getter/Setter
	// Return true, if _item is equipped to _brother in the itemslot _slot
	// Return false otherwise
	q.HD_isEquippedIn <- function( _item, _slot )
	{
		foreach (equippedItem in this.getAllItemsAtSlot(_slot))
		{
			if (::MSU.isEqual(equippedItem, _item)) return true;
		}
		return false;
	}

	q.getWeight <- function( _slots = null )
	{
		local staminaModifier = this.getStaminaModifier(_slots);
		return ::Math.max(0, -1 * staminaModifier);
	}
});

::Hardened.HooksMod.hookTree("scripts/items/item_container", function(q) {
	q.unequip = @(__original) function( _item )
	{
		local ret = __original(_item);

		// If the unequip was successful and all connections have been severed, we trigger our after event
		if (ret) _item.HD_onAfterUnEquip();

		return ret;
	}
});
