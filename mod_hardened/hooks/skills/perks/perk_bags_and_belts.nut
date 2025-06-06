::Hardened.HooksMod.hook("scripts/skills/perks/perk_bags_and_belts", function(q) {
	// Public
	q.m.AdditionalBagSlots <- 2;
	q.m.WeightStaminaMult <- 0.0;
	q.m.WeightInitiativeMult <- 0.0;

	// Overwrite, because we no longer set the unlocked bag slots to 4 directly, instead we manipulate a new character property
	q.onUpdate = @() function( _properties )
	{
		_properties.BagSlots += this.m.AdditionalBagSlots;
		_properties.WeightStaminaMult[::Const.ItemSlot.Bag] *= this.m.WeightStaminaMult;
	}

	// Overwrite, because the item recover logic is now handled by hd_bag_item_manager
	q.onRemoved = @() function() {}
});
