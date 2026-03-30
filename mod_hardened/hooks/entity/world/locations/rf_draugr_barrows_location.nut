::Hardened.HooksMod.hook("scripts/entity/world/locations/rf_draugr_barrows_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200 * ::Hardened.Global.FactionDifficulty.Draugr;		// Reforged: 250
	}
});
