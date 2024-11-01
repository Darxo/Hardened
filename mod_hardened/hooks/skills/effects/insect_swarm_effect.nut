::Hardened.HooksMod.hook("scripts/skills/effects/insect_swarm_effect", function(q) {
// Public
	q.m.MeleeSkillMult <- 0.70;		// In Vanilla this is 0.5
	q.m.RangedSkillMult <- 0.70;	// In Vanilla this is 0.5
	q.m.MeleeDefenseMult <- 0.70;	// In Vanilla this is 0.5
	q.m.RangedDefenseMult <- 0.70;	// In Vanilla this is 0.5
	q.m.InitiativeMult <- 1.0;	// In Vanilla this is 0.5
	q.m.DisablesZoneOfControl <- true;

	q.getTooltip = @(__original) function()
	{
		local ret = this.skill.getTooltip();

		if (this.m.MeleeSkillMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.MeleeSkillMult) + " [Melee Skill|Concept.MeleeSkill]"),
			});
		}

		if (this.m.RangedSkillMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.RangedSkillMult) + " [Ranged Skill|Concept.RangeSkill]"),
			});
		}

		if (this.m.MeleeDefenseMult != 1.0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.MeleeDefenseMult) + " [Melee Defense|Concept.MeleeDefense]"),
			});
		}

		if (this.m.RangedDefenseMult != 1.0)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.RangedDefenseMult) + " [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		if (this.m.InitiativeMult != 1.0)
		{
			ret.push({
				id = 14,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.InitiativeMult) + " [Initiative|Concept.Initiative]"),
			});
		}

		if (this.m.DisablesZoneOfControl)
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Does not exert [Zone of Control|Concept.ZoneOfControl]"),
			});
		}

		return ret;
	}

	// Overwrite vanilla effect because we now make it much more moddable
	q.onUpdate = @() function( _properties )
	{
		_properties.MeleeSkillMult *= this.m.MeleeSkillMult;
		_properties.RangedSkillMult *= this.m.RangedSkillMult;
		_properties.MeleeDefenseMult *= this.m.MeleeDefenseMult;
		_properties.RangedDefenseMult *= this.m.RangedDefenseMult;
		_properties.InitiativeMult *= this.m.InitiativeMult;
		if (this.m.DisablesZoneOfControl)
		{
			_properties.CanExertZoneOfControl = false;
		}
	}
});
