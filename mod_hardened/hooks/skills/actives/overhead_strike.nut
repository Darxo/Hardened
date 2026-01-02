::Hardened.HooksMod.hook("scripts/skills/actives/overhead_strike", function(q) {
	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			_properties.MeleeSkill -= 5;	// This reverts the vanilla +5 Modifier
		}
	}
});
