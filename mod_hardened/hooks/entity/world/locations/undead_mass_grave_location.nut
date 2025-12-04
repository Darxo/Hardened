::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_mass_grave_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200 * ::Hardened.Global.FactionDifficulty.Skeletons;		// Vanilla: 200
	}
});
