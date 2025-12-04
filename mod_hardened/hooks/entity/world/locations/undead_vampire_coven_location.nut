::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_vampire_coven_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200 * ::Hardened.Global.FactionDifficulty.Vampires;		// Vanilla: 250
	}
});

