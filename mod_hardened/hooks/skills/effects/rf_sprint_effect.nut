::Hardened.HooksMod.hook("scripts/skills/effects/rf_sprint_effect", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		foreach (index, entry in ret)
		{
			if (entry.id == 10 && ::String.contains(entry.text, "more Fatigue built per tile traveled"))
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
