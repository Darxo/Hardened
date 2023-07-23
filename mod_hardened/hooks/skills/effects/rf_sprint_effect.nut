::mods_hookExactClass("skills/effect/rf_sprint_effect", function(o) {
	local oldGetTooltip = o.getTooltip;
	o.getTooltip = function()
	{
		local ret = oldGetTooltip();
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
	o.onUpdate = function( _properties )
	{
		_properties.MovementAPCostAdditional -= 1;
		// _properties.MovementFatigueCostMult *= 2.0;
	}
});
