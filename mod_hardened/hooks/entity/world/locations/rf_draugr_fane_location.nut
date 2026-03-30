::Hardened.HooksMod.hook("scripts/entity/world/locations/rf_draugr_fane_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 300 * ::Hardened.Global.FactionDifficulty.Draugr;		// Reforged: 600
	}
});
