::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_throw_net", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		local generator = __original(_entity);	// Get the original generator

		local ret = resume generator;	// Variable to hold the value yielded by the generator

		// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
		while (ret == null)
		{
			yield ret;
			ret = resume generator;
		}

		if (ret != ::Const.AI.Behavior.Score.Zero)	// We need the ret != null check because onEvaluate is a generator
		{
			foreach (opponent in this.getStrategy().getKnownOpponents())
			{
				local targetDistance = _entity.getTile().getDistanceTo(opponent.Actor.getTile());
				if (targetDistance == 1)
				{
					ret *= ::Const.AI.Behavior.OffhandDiscardDoubleGripMult;
					break;
				}
			}
		}

		return ret;
	}
});
