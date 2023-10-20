::mods_hookExactClass("items/shields/shield", function(o) {
	local getTooltip = o.getTooltip;
	o.getTooltip = function()
	{
		local ret = getTooltip();
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
