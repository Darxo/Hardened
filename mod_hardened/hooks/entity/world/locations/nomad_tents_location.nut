::Hardened.HooksMod.hook("scripts/entity/world/locations/nomad_tents_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 100 * ::Hardened.Global.FactionDifficulty.Nomads;		// Vanilla: 70
		this.m.VisibilityMult = 1.0;	// Vanilla: 0.8
	}
});
