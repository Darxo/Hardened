::Hardened.HooksMod.hook("scripts/entity/world/locations/orc_hideout_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 100 * ::Hardened.Global.FactionDifficulty.Orcs;		// Vanilla: 70
	}
});
