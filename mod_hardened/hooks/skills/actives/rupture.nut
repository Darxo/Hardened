// This hook also removes the natural hitchance bonus from rupture but that is ok, because we want that removed anyways
::Hardened.removeTooClosePenalty("scripts/skills/actives/rupture");

::Hardened.HooksMod.hook("scripts/skills/actives/rupture", function(q) {
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
