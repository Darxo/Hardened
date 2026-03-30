::Hardened.HooksMod.hook("scripts/entity/world/locations/rf_draugr_crypt_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Draugr;		// Reforged: 400
	}
});
