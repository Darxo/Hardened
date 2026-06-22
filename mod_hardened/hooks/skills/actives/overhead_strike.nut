::Hardened.HooksMod.hook("scripts/skills/actives/overhead_strike", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		::Hardened.util.HD_deleteBulletPoint(ret, function(_entry) {
			return (_entry.id == 6) && (_entry.icon == "ui/icons/hitchance.png");
		});

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			_properties.MeleeSkill -= 5;	// This reverts the vanilla +5 Modifier
		}
	}
});
