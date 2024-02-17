::Hardened.HooksMod.hook("scripts/skills/actives/strike_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.HitChanceBonus = 0;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png" && ::String.contains(entry.text, "+5%"))
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
			if (!this.m.ApplyAxeMastery)
			{
				_properties.MeleeSkill -= 5;	// This reverts the vanilla +5 Modifier for non-axe users
			}

			if (this.m.HitChanceBonus == -10)
			{
				this.m.HitChanceBonus = -15;
			}
			else
			{
				this.m.HitChanceBonus = 0;
			}
		}
	}
});
