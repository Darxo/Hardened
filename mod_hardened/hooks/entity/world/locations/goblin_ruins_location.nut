::Hardened.HooksMod.hook("scripts/entity/world/locations/goblin_ruins_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 150 * ::Hardened.Global.FactionDifficulty.Goblins;		// Vanilla: 150
	}
});
