::Hardened.HooksMod.hook("scripts/entity/world/locations/bandit_hideout_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 100 * ::Hardened.Global.FactionDifficulty.Brigands;		// Vanilla: 80
	}
});
