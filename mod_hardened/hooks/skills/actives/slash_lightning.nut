::Hardened.HooksMod.hook("scripts/skills/actives/slash_lightning", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.HitChanceBonus -= 10;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 7)
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
			_properties.MeleeSkill -= 10;	// This reverts the vanilla +10 Modifier
		}
	}
});
