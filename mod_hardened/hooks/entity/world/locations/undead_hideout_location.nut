::Hardened.HooksMod.hook("scripts/entity/world/locations/undead_hideout_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 100 * ::Hardened.Global.FactionDifficulty.Zombies;		// Vanilla: 80
	}
});
