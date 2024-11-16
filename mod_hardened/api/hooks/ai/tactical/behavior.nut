::Hardened.HooksMod.hook("scripts/ai/tactical/behavior", function(q) {
	q.queryTargetValue = @(__original) function( _entity, _target, _skill = null )
	{
		local ret = __original(_entity, _target, _skill);

		// User Skills
		foreach (userSkill in _entity.getSkills().m.Skills)
		{
			ret *= userSkill.getQueryTargetMultAsUser(_target, _skill);
		}

		// Target Skills
		foreach (targetSkill in _target.getSkills().m.Skills)
		{
			ret *= targetSkill.getQueryTargetMultAsTarget(_entity, _skill);
		}

		return ret;
	}
});
