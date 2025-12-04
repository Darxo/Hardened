::Hardened.HooksMod.hook("scripts/entity/world/locations/orc_settlement_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Orcs;		// Vanilla: 350
	}
});
