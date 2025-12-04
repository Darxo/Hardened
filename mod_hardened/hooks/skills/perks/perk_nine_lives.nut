::Hardened.HooksMod.hook("scripts/skills/perks/perk_nine_lives", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "Slip past death by sheer instinct!";
	}

	// Overwrite, because we prefer a simple static description over a verbose and dynamic one
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
			text = "Survive the next time you would receive fatal damage and recover " + ::MSU.Text.colorPositive(this.m.MinHP + "-" + this.m.MaxHP) + ::Reforged.Mod.Tooltips.parseString(" [Hitpoints|Concept.Hitpoints]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "When receiving fatal damage, remove all damage over time effects from you",
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("When receiving fatal damage, gain [Heightened Reflexes|Skill+nine_lives_effect]"),
		});

		return ret;
	}
});
