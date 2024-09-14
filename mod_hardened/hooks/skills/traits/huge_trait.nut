::Hardened.HooksMod.hook("scripts/skills/traits/huge_trait", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/rf_reach.png")
			{
				ret.remove(index);	// Remove entry about reach
				break;
			}
		}

		return ret;
	}

	// Revert any changes done to reach
	q.onUpdate = @(__original) function(_properties)
	{
		local oldReach = _properties.Reach;
		__original(_properties);
		_properties.Reach = oldReach;
	}
});
