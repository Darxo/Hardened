::Hardened.HooksMod.hook("scripts/skills/actives/aimed_shot", function(q) {
	q.m.HD_DamageRegularMult <- 1.0;		// Vanilla: 1.1

	q.onAnySkillUsed = @(__original) { function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local oldDamageRegularMult = _properties.DamageRegularMult;
			__original(_skill, _targetEntity, _properties);
			_properties.DamageRegularMult = oldDamageRegularMult;

			_properties.DamageRegularMult *= this.m.HD_DamageRegularMult;
		}
	}}.onAnySkillUsed;
});
