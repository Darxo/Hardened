::Hardened.HooksMod.hook("scripts/skills/traits/brute_trait", function(q) {
	q.m.HeadDamageMult <- 1.15;

	q.onBeforeTargetHit = @(__original) function( _skill, _targetEntity, _hitInfo )
	{
		if (_skill.isAttack() && !_skill.isRanged() && _hitInfo.BodyPart == ::Const.BodyPart.Head)
		{
			// Vanilla Fix: In Vanilla this trait only buffs hitpoint damage and is negated by steel brow. This is inaccurate compared to description
			// We need to apply the damage modifier here, because only HitInfo knows for sure, whether we actually hit the head
			_hitInfo.DamageRegular *= this.m.HeadDamageMult;
			_hitInfo.DamageArmor *= this.m.HeadDamageMult;
		}

		__original(_skill, _targetEntity, _hitInfo);
	}

	// Overwrite, because we no longer apply the damage bonus using vanillas old calculation
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties ) { }
});
