::Hardened.HooksMod.hook("scripts/items/shields/shield", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		foreach (index, entry in ret)
		{
			if (entry.id == 8 && entry.text.find("Ignores ") != null)
			{
				ret.remove(index);	// Remove mention about ReachIgnore on shields
				break;
			}
		}
		return ret;
	}
});
