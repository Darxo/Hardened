::Hardened.HooksMod.hook("scripts/entity/world/locations/orc_camp_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200 * ::Hardened.Global.FactionDifficulty.Orcs;		// Vanilla: 140
	}

	// Overwrite, because we adjust the vanilla loot for this location
	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);

		// This location now drops an additional guaranteed loot item. In vanilla there is only a 50% chance to drop one of those
		this.dropTreasure(1, [
			"trade/furs_item",
			"trade/copper_ingots_item",
		], _lootTable);
	}
});
