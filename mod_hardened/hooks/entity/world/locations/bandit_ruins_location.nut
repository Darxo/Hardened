::Hardened.HooksMod.hook("scripts/entity/world/locations/bandit_ruins_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 150 * ::Hardened.Global.FactionDifficulty.Brigands;		// Vanilla: 150
	}
});
