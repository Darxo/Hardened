::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_necromancers_lair_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200;		// Vanilla: 150
	}

	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);

		this.dropArmorParts(::Math.rand(5, 15), _lootTable);	// Vanilla: 0
	}
});
