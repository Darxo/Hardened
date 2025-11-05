::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_crypt_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250;		// Vanilla: 180
	}

	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);

		this.dropFood(1, [		// Vanilla: 0
			"wine_item",
			"wine_item",
			"mead_item",
		], _lootTable);
		this.dropArmorParts(::Math.rand(8, 20), _lootTable);	// Vanilla: 0
	}
});
