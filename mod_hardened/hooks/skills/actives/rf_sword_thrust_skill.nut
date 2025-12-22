::Hardened.HooksMod.hook("scripts/skills/actives/rf_sword_thrust_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

	// Reforged
		this.m.MeleeSkillAdd = 0;	// Reforged: 20
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.HitChanceBonus == 0)		// Reforged Fix: Hide hitchance tooltip when there is no bonus
		{
			foreach (index, entry in ret)
			{
				if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png")
				{
					ret.remove(index);
					break;
				}
			}
		}

		return ret;
	}
});
