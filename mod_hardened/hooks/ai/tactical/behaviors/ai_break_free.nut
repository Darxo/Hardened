::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_break_free", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		local ret = __original(_entity);

		// The current Melee Defense on our character makes it either less or more likely that we want to use break free
		local mdefScore = _entity.getCurrentProperties().getMeleeDefense() - 20;	// A character with 0 Melee Defense is 20% less likely to use break free
		local scoreMult = 1.0 + (mdefScore / 100.0);
		ret *= scoreMult;

		return ret;
	}
});
