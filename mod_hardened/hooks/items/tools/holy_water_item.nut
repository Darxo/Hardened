::Hardened.HooksMod.hook("scripts/items/tools/holy_water_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 250; 	// Vanilla: 100
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (id, entry in ret)
		{
			if ("text" in entry && ::String.contains(entry.text, "bystanders"))
			{
				ret.remove(id);
				break;
			}
		}

		return ret;
	}
});
