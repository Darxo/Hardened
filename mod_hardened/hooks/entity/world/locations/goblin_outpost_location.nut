::Hardened.HooksMod.hook("scripts/entity/world/locations/goblin_outpost_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200 * ::Hardened.Global.FactionDifficulty.Goblins;		// Vanilla: 200
	}
});
