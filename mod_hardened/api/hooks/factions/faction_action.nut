::Hardened.HooksMod.hook("scripts/factions/faction_action", function(q) {
	// Public
	q.m.HD_ScoreOverwrite <- null;	// Is set to a value, then that value will be assigned as score, whenever this action rolls a score > 0

	q.update = @(__original) function( _isNewCampaign = false )
	{
		__original(_isNewCampaign);

		if (this.getScore() > 0 && this.m.HD_ScoreOverwrite != null)
		{
			this.m.Score = this.m.HD_ScoreOverwrite;
		}
	}

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
