::Hardened.HooksMod.hook("scripts/entity/world/locations/cp_beast_cave_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 150 * ::Hardened.Global.FactionDifficulty.Beasts;		// Crock Pot: 140
	}
});
