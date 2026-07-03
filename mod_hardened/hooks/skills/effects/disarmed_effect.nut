::Hardened.HooksMod.hook("scripts/skills/effects/disarmed_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This characters weapon has been temporarily pulled out of their hand.";

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
			text = "Cannot use Skills from " + ::Reforged.NestedTooltips.getNestedItemName(this.getContainer().getActor().getMainhandItem()),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Is removed when you swap away from your weapon",
		});

		return ret;
	}
});
