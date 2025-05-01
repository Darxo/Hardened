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
	q.getWeight <- function( _slots = null )
	{
		local staminaModifier = this.getStaminaModifier(_slots);
		return ::Math.max(0, -1 * staminaModifier);
	}
});
