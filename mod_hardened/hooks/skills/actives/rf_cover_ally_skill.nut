::Hardened.HooksMod.hook("scripts/skills/actives/rf_cover_ally_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("Cover an adjacent ally with your equipped shield. Cannot be used while rooted or stunned.");

		// MSU Member
		this.m.AIBehaviorID = null;		// AI will no longer consider or use this skill
	}

	// Overwrite, because we don't require an adjacent ally for this skill to be previewable
	q.isUsable = @() function()
	{
		local actor = this.getContainer().getActor();
		return this.skill.isUsable() && !actor.getCurrentProperties().IsRooted && !this.getContainer().hasSkill("effects.rf_covering_ally");
	}

	// Overwrite, because that is simpler than adjusting all reforged tooltip lines
	q.getTooltip = @() function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("The target gains [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense] equal to the base defenses of your equipped shield"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("You lose [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense] equal to the base defenses of your equipped shield"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your next [turn|Concept.Turn]"),
		});

		if (this.getContainer().getActor().getCurrentProperties().IsRooted || this.getContainer().getActor().getCurrentProperties().IsStunned)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Cannot be used while [Rooted|Concept.Rooted] or [Stunned|Skill+stunned_effect]")),
			});
		}

		if (this.getContainer().hasSkill("effects.rf_covering_ally"))
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("Cannot be used when already [providing cover|Skill+rf_covering_ally_effect] to an ally")),
			});
		}

		return ret;
	}
});
