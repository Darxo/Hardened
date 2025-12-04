::Hardened.HooksMod.hook("scripts/entity/world/locations/bandit_camp_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200 * ::Hardened.Global.FactionDifficulty.Brigands;		// Vanilla: 180
	}
});
