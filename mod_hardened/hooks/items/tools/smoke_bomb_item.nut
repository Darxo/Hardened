::Hardened.HooksMod.hook("scripts/items/tools/smoke_bomb_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400; // Vanilla value
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 5 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::MSU.String.replace(entry.text, " one ", " two ");
				break;
			}
		}

		return ret;
	}
});
