::Hardened.HooksMod.hook("scripts/entity/world/locations/goblin_settlement_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Goblins;		// Vanilla: 350
	}
});
