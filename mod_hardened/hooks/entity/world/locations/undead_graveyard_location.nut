::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_graveyard_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 150 * ::Hardened.Global.FactionDifficulty.Zombies;		// Vanilla: 130
	}

	// Overwrite, because we adjust the vanilla loot for this location
	q.onDropLootForPlayer = @() function( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);

		local treasure = [
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/signet_ring_item",
		];
		this.dropTreasure(1, treasure, _lootTable);		// Vanilla: 0-1

		this.dropMoney(::Math.rand(10, 80), _lootTable);	// Vanilla: 1-200
		this.dropArmorParts(::Math.rand(2, 8), _lootTable);	// Vanilla: 0
	}
});
