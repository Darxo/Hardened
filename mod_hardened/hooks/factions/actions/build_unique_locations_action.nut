::Hardened.HooksMod.hook("scripts/factions/actions/build_unique_locations_action", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Feat: Reduce the range of where the Oracle Location can spawn to prevent extreme spawns and slightly improve performance
		this.m.HD_OracleY[0] = 0.1;
		this.m.HD_OracleY[1] = 0.35;
	}
});
