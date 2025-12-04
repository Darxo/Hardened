::Hardened.HooksMod.hook("scripts/entity/world/locations/nomad_tent_city_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Nomads;		// Vanilla: 300
	}
});
