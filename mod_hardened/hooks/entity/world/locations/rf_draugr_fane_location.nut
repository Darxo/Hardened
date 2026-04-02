::Hardened.HooksMod.hook("scripts/entity/world/locations/rf_draugr_fane_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// We make this location easier to spot, as it is guaranteed to spawn in mountains, which have a VisibilityMult of 0.5
		this.m.VisibilityMult = 1.5;	// Reforged: 1.0

		this.m.Resources = 300 * ::Hardened.Global.FactionDifficulty.Draugr;		// Reforged: 600
	}
});
