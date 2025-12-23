::Hardened.HooksMod.hook("scripts/ai/tactical/strategy", function(q) {
	// Public
	q.m.HD_HitDifferenceDefenseStop <- 3;	// When our faction was hit this many times more than we hit the enemy, we stop defending

	// Private
	q.m.Stats.HD_DealtHitToEnemy <- 0;	// How many times did an actor from our faction hit one of our enemies?
	q.m.Stats.HD_WasHitByEnemy <- 0;	// How many times did one of our enemies do damage to an actor from our faction?

	q.updateDefending = @(__original) function()
	{
		// Feat: We cancel our defending strategy, if we were hit HD_HitDifferenceDefenseStop more than we hit an enemy
		// This prevents cheese scenarios where the AI thinks
		//	- it has Range advantage, even though the enemy fields a strategy, that allow them to be much more effective
		//	- it's fine to hold a defensive position, even though the enemy attacks and pokes at us
		if (this.m.Stats.HD_WasHitByEnemy >= this.m.Stats.HD_DealtHitToEnemy + this.m.HD_HitDifferenceDefenseStop)
		{
			return false;
		}

		return __original();
	}
});
