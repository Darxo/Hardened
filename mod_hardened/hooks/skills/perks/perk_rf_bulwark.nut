::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bulwark", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 11)
			{
				ret.remove(index);	// Remove entry about bonus against negative morale checks, as that part is removed from the perk
				break;
			}
		}

		return ret;
	}

	// Overwrite, because we no longer grant a bonus against negative morale checks
	q.onUpdate = @() function( _properties )
	{
		_properties.Bravery += this.getBonus();
	}
});
