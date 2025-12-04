::Hardened.HooksMod.hook("scripts/entity/world/locations/nomad_hidden_camp_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200 * ::Hardened.Global.FactionDifficulty.Nomads;		// Vanilla: 180
	}
});
