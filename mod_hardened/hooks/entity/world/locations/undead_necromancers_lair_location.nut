::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_necromancers_lair_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Zombies;		// Vanilla: 150; Reforged: 300
	}

	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);

		this.dropArmorParts(::Math.rand(8, 20), _lootTable);	// Vanilla: 0
	}
});
