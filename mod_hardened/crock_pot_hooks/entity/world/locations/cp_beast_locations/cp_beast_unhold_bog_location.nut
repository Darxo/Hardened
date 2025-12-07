::Hardened.HooksMod.hook("scripts/entity/world/locations/cp_beast_locations/cp_beast_unhold_bog_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200 * ::Hardened.Global.FactionDifficulty.Beasts;		// Crock Pot: 140
	}
});
