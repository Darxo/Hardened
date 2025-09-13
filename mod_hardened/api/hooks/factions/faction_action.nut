::Hardened.HooksMod.hook("scripts/factions/faction_action", function(q) {
	// Overwrite, because action scaling is now done by ::Hardened.Global.getWorldDifficultyMult() scaling globally
	q.getScaledDifficultyMult = @() function()
	{
		local ret = 1.0;
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		return ret;
	}

	// Overwrite, because action scaling is now done by ::Hardened.Global.getWorldDifficultyMult() scaling globally
	q.getReputationToDifficultyLightMult = @() function()
	{
		local ret = 1.0;
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		return ret;
	}
});
