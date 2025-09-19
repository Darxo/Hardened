::Hardened.HooksMod.hook("scripts/factions/faction_action", function(q) {
	// Overwrite, because action scaling is now done by scaling with ::Hardened.Global.getWorldDifficultyMult()
	q.getScaledDifficultyMult = @() function()
	{
		local ret = 1.0;
		ret *= ::Hardened.Global.getWorldDifficultyMult();
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		return ret;
	}

	// Overwrite, because action scaling is now done by scaling with ::Hardened.Global.getWorldDifficultyMult()
	q.getReputationToDifficultyLightMult = @() function()
	{
		local ret = 1.0;
		ret *= ::Hardened.Global.getWorldDifficultyMult();
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		return ret;
	}
});
