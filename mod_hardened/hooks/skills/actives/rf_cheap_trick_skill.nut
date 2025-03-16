::Hardened.HooksMod.hook("scripts/skills/actives/rf_cheap_trick_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 || entry.id == 11)
			{
				entry.text = ::MSU.String.replace(entry.text, "attack", "attack skill");
			}
		}

		return ret;
	}
});
