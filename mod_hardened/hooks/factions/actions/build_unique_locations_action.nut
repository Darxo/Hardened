::Hardened.HooksMod.hook("scripts/factions/actions/build_unique_locations_action", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.HD_DistanceToOthers = 10;	// Vanilla: 15; We reduce this to improve campaign generation speed and fix some situations where certain unique locations dont spawn at all because of no space

		// Feat: Reduce the range of where the Oracle Location can spawn to prevent extreme spawns and slightly improve performance
		this.m.HD_OracleY[0] = 0.1;
		this.m.HD_OracleY[1] = 0.35;
	}
});
