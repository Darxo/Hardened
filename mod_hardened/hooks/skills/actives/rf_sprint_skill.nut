::Hardened.HooksMod.hook("scripts/skills/actives/rf_sprint_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 1;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		foreach (index, entry in ret)
		{
			if (entry.id == 10 && ::String.contains(entry.text, "Fatigue cost for movement on all terrain will be increased by"))
			{
				ret.remove(index);
				break;
			}
		}
		return ret;
	}
});
