::Hardened.HooksMod.hook("scripts/skills/actives/gash_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

	// Reforged
		this.m.MeleeSkillAdd = 0;	// Reforged: 5
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png")	// Reforged currently still displays this tooltip even if the bonus is 0
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}
});
