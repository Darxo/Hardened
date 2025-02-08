// This hook also removes the natural hitchance bonus from strike but that is ok, because we want that removed anyways
::Hardened.removeTooClosePenalty("scripts/skills/actives/strike_skill");

::Hardened.HooksMod.hook("scripts/skills/actives/strike_skill", function(q) {
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
});
