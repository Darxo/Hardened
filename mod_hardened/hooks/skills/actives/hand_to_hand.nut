::Hardened.HooksMod.hook("scripts/skills/actives/hand_to_hand", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png")
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			_properties.MeleeSkill += 10;	// This reverts the vanilla -10 Modifier
		}
	}
});
