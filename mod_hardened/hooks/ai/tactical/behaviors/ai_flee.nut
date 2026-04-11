::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_flee", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		// Fix: If this actor has the retreat behavior and that ones score is > 0, or its tries have been > 2, then we ignore this ai_flee behavior
		// Instead we full let ai_retreat handle the retreating, because our script (ai_flee) doesnt know how to seek the border from within zone of control
		local retreatBehavior = this.getAgent().getBehavior(::Const.AI.Behavior.ID.Retreat);
		if (retreatBehavior != null && (retreatBehavior.getScore() != 0 || retreatBehavior.m.HD_AttemptsThisTurn >= 2))
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		return __original(_entity);
	}
});
