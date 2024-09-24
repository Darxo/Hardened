::Hardened.HooksMod.hook("scripts/skills/effects/rf_sprint_effect", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		foreach (index, entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/fatigue.png")
			{
				ret.remove(index);
				break;
			}
		}
		return ret;
	}

	// This overwrite approach is just a bit quicker to apply
	q.onUpdate = @() function( _properties )
	{
		_properties.MovementAPCostAdditional -= 1;
		// _properties.MovementFatigueCostMult *= 2.0;
	}
});
