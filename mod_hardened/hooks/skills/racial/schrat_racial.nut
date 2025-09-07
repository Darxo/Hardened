::Hardened.HooksMod.hook("scripts/skills/racial/schrat_racial", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 15)
			{
				ret.remove(index);	// Remove the tooltip about the vanilla 70% damage mitigation
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// We revert the damage mult changes as that effect is now implemented via a new perk
		local oldDamageReceivedTotalMult = _properties.DamageReceivedTotalMult;
		__original(_properties);
		_properties.DamageReceivedTotalMult = oldDamageReceivedTotalMult;
	}
});
