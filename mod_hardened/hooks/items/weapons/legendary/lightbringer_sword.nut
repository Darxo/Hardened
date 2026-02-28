::Hardened.HooksMod.hook("scripts/items/weapons/legendary/lightbringer_sword", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}
});
