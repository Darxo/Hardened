::Hardened.HooksMod.hook("scripts/entity/world/locations/rf_bandit_fort_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Brigands;		// Reforged: 300
	}
});
