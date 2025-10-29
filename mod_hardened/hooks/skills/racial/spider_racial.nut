::Hardened.HooksMod.hook("scripts/skills/racial/spider_racial", function(q) {
	// Vanilla Fix: Vanilla never checks, whether _targetEntity is null, before calling a function on it
	// We prevent the vanilla logic from running when _targetEntity is null
	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null) return;

		__original(_skill, _targetEntity, _properties);
	}
});
