::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_tricksters_purses", function(q) {
	// Public
	q.m.AdditionalBagSlots <- 2;

	// Overwrite, because we no longer set the unlocked bag slots to 4 directly, instead we manipulate a new character property
	q.onUpdate = @() function( _properties )
	{
		_properties.BagSlots += this.m.AdditionalBagSlots;
	}

	// Overwrite, because the item recover logic is now handled by hd_bag_item_manager
	q.onRemoved = @() function()
	{
		this.getContainer().removeByID("actives.rf_pocket_sand_skill");		// Same as Reforged
	}
});
