::Hardened.HooksMod.hook("scripts/skills/effects/berserker_mushrooms_effect", function(q) {
	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill.isAttack() && !_skill.isRanged())	// We make sure to ignore any non-applicable skills, so that the vanilla rage sfx is only played for the correct skills
		{
			__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		}
	}

	q.onTargetMissed = @(__original) function( _skill, _targetEntity )
	{
		if (_skill.isAttack() && !_skill.isRanged())	// We make sure to ignore any non-applicable skills, so that the vanilla rage sfx is only played for the correct skills
		{
			__original(_skill, _targetEntity);
		}
	}
});
