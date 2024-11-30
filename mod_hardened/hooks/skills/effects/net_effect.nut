::Hardened.HooksMod.hook("scripts/skills/effects/net_effect", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		foreach (index, entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/initiative.png")
			{
				ret.remove(index);	// We no longer display the initiative tooltip because that part of the effect is removed
			}
		}
		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local oldInitiativeMult = _properties.InitiativeMult;
		__original(_properties);
		_properties.InitiativeMult = oldInitiativeMult;
	}
});
