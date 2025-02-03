::Hardened.HooksMod.hook("scripts/skills/effects/rf_worn_down_effect", function(q) {
	q.m.MeleeDefenseMult <- 0.8;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// Remove the existing tooltips
		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			if (ret[index].id == 10 || ret[index].id == 11)
			{
				ret.remove(index);
			}
		}

		if (this.m.MeleeDefenseMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::MSU.Text.colorizeMultWithText(this.m.MeleeDefenseMult) + ::Reforged.Mod.Tooltips.parseString(" [Melee Defense|Concept.MeleeDefense]"),
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::Reforged.Mod.Tooltips.parseString("[Recover|Skill+recover_skill] can no longer be used"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the end of your [turn|Concept.Turn]."),
		});

		return ret;
	}

	// Overwrite because we completely replace reforged effects
	q.onUpdate = @() function( _properties )
	{
		local recoverSkill = this.getContainer().getSkillByID("actives.recover");
		if (recoverSkill != null)
		{
			recoverSkill.m.IsUsable = false;
			this.getContainer().getActor().setDirty(true);	// Update the UI so that Recover is instantly shown as disabled
		}

		_properties.MeleeDefenseMult *= this.m.MeleeDefenseMult;
	}

	q.onRemoved = @(__original) function()
	{
		__original();

		// Make sure that recover is usable again the moment that this skill is removed
		local recoverSkill = this.getContainer().getSkillByID("actives.recover");
		if (recoverSkill != null)
		{
			recoverSkill.m.IsUsable = true;
			this.getContainer().getActor().setDirty(true);	// Update the UI so that Recover is instantly shown as enabled
		}
	}

// MSU Events
	q.onQueryTooltip <- function( _skill, _tooltip )
	{
		if (_skill.getID() == "actives.recover")
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because of " + ::Reforged.NestedTooltips.getNestedSkillName(this)),
			});
		}
	}
});
