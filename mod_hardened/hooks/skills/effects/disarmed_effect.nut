::Hardened.HooksMod.hook("scripts/skills/effects/disarmed_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This characters weapon has been temporarily pulled out of their hand. Switching to a different weapon will remove this effect immediately. Does not work on [headless|Skill+hd_headless_effect] characters";

		this.m.HD_LastsForTurns = 1;
	}

	// Overwrite, because we want to remove the semi-hard-coded description that vanilla inserts directly within this function
	q.getDescription = @() function()
	{
		return this.skill.getDescription();
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Cannot use Weapon Skills",
		});

		return ret;
	}
});
