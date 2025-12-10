::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_ruins_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 150 * ::Hardened.Global.FactionDifficulty.Zombies;		// Vanilla: 180
	}

	// Overwrite, because we adjust the vanilla loot for this location
	q.onDropLootForPlayer = @() function( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);

		local treasure = [
			"loot/silver_bowl_item",
			"loot/gemstones_item",
			"loot/signet_ring_item",
			"loot/signet_ring_item",
			"loot/ancient_gold_coins_item",
			"loot/ornate_tome_item",
			"loot/golden_chalice_item"
		];
		this.dropTreasure(1, treasure, _lootTable);		// Vanilla: 2-3

		this.dropMoney(::Math.rand(20, 100), _lootTable);	// Vanilla: 0-200
		this.dropArmorParts(::Math.rand(2, 10), _lootTable);	// Vanilla: 0
	}

	q.onInit = @(__original) function()
	{
		__original();

		// Undead Ruins contain skeletons while in the south, so we adjust the resources accordingly
		local isSouthern = this.getTile().Type == ::Const.World.TerrainType.Desert || this.getTile().Type == ::Const.World.TerrainType.Steppe || this.getTile().Type == ::Const.World.TerrainType.Oasis || this.getTile().TacticalType == ::Const.World.TerrainTacticalType.DesertHills;
		if (isSouthern)
		{
			this.m.Resources = 150 * ::Hardened.Global.FactionDifficulty.Skeletons;
		}
	}
});
