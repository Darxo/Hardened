::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_buried_castle_location", function(q) {
	// Feat: Display the original location name for ruined
	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);

		// This location now also drops a random utility throwing pot
		this.dropTreasure(1, [
			"tools/daze_bomb_item",
			"tools/fire_bomb_item",
			"tools/smoke_bomb_item",
		], _lootTable);
	}
});
