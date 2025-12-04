::Hardened.HooksMod.hook("scripts/entity/world/locations/barbarian_sanctuary_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Barbarians;		// Vanilla: 325
	}
});
