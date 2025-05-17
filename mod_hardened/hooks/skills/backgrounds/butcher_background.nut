::Hardened.HooksMod.hook("scripts/skills/backgrounds/butcher_background", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			// We remove the tooltip about the bonus introduced by Reforged
			if (entry.id == 10 && entry.icon == "ui/icons/hitchance.png") ret.remove(index);
		}

		return ret;
	}

	// Overwrite, because we disable the bonus introduced by Reforged
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties ) {}
});
