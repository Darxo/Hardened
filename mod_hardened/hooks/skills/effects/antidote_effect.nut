::Hardened.HooksMod.hook("scripts/skills/effects/antidote_effect", function(q) {

	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Immune to Toxins";	// Vanilla: Immune to Poison
		this.m.HD_LastsForTurns = this.m.TurnsLeft;
	}

	q.onAdded = @(__original) function()
	{
		__original();
		this.m.HD_LastsForTurns = this.m.TurnsLeft;
	}

	// Overwrite, because we don't display the turn duration here
	q.getDescription = @() function()
	{
		return "This character has taken antidote and is temporarily immune to any kind of toxins.";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Immune to Poison",
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Immune to Miasma",		// This already implied by granting immunity to poison, but it may not be apparent to the player
		});

		return ret;
	}
});
