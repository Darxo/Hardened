// This hook also removes the natural hitchance bonus from impale but that is ok, because we want that removed anyways
::Hardened.removeTooClosePenalty("scripts/skills/actives/impale");

::Hardened.HooksMod.hook("scripts/skills/actives/impale", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png" && ::String.contains(entry.text, "+10%"))
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}
});
