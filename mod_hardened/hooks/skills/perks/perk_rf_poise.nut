::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_poise", function(q) {

	q.getTooltip = @(__original) function()
	{
		local ret = __original()

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/reach.png")
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		// Do nothing: Poise no longer grants reach ignore
	}
});
