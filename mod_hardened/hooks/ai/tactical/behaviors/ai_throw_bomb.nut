::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_throw_bomb", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		local ret = __original(_entity);

		if (ret != ::Const.AI.Behavior.Score.Zero)
		{
			foreach (opponent in this.getStrategy().getKnownOpponents())
			{
				local targetDistance = _entity.getTile().getDistanceTo(opponent.Actor.getTile());
				if (targetDistance == 1)
				{
					ret *= ::Const.AI.Behavior.OffhandDiscardDoubleGripMult;	// We are in melee range of an enemy. We should get rid of our net to enable double grip
					break;
				}
			}
		}

		return ret;
	}
});
