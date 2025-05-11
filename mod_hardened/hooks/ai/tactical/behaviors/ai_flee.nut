::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_flee", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		// Fix: If this actor has the retreat behavior and that ones score is > 0, then we ignore this ai_flee behavior
		// Instead we full let ai_retreat handle the retreating, because our script (ai_flee) doesnt know how to seek the border from within zone of control
		if (this.getAgent().getBehavior(::Const.AI.Behavior.ID.Retreat) != null && this.getAgent().getBehavior(::Const.AI.Behavior.ID.Retreat).getScore() != 0)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		return __original(_entity);
	}
});
