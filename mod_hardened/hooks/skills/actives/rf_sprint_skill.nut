::mods_hookExactClass("skills/actives/rf_sprint_skill", function(o) {

	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.ActionPointCost = 1;
	}

	local oldGetTooltip = o.getTooltip;
	o.getTooltip = function()
	{
		local ret = oldGetTooltip();
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
