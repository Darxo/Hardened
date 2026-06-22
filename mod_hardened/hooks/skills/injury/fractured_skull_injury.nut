::Hardened.HooksMod.hook("scripts/skills/injury/fractured_skull_injury", function(q) {
	q.m.HeadDamageMultPct <- 0.5;
	q.m.Vision <- -1;				// Vanilla: -2
	q.m.MeleeSkillMult <- 0.7;		// Vanilla: 0.5
	q.m.RangedSkillMult <- 0.7;		// Vanilla: 0.5
	q.m.MeleeDefenseMult <- 0.7;	// Vanilla: 0.5
	q.m.RangedDefenseMult <- 0.7;	// Vanilla: 0.5
	q.m.InitiativeMult <- 0.7;		// Vanilla: 0.5

	// Overwrite, because we change too many lines at once
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		if (this.m.HeadDamageMultPct != 0.0)
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "Take " + ::MSU.Text.colorPositive("+50% ") + ::Reforged.Mod.Tooltips.parseString("[Critical Damage|Concept.CriticalDamage] on a [hit to the head|Concept.ChanceToHitHead]"),
			});
		}

		if (this.m.Vision != 0)
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/vision.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.Vision, {AddSign = true}) + " [Vision|Concept.SightDistance]"),
			});
		}

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
		return ret;
	}

	// Overwrite, because we change too many values from vanilla
	q.onUpdate = @() function( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!this.HD_isAffectedByInjuries(_properties)) return;

		_properties.Vision += this.m.Vision;
		_properties.MeleeSkillMult *= this.m.MeleeSkillMult;
		_properties.RangedSkillMult *= this.m.RangedSkillMult;
		_properties.MeleeDefenseMult *= this.m.MeleeDefenseMult;
		_properties.RangedDefenseMult *= this.m.RangedDefenseMult;
		_properties.InitiativeMult *= this.m.InitiativeMult;
	}

	// Overwrite because we now calculate the armor mitigation with a helper function and we reduce the conditions for this effect to apply
	q.onBeforeDamageReceived = @() function( _attacker, _skill, _hitInfo, _properties )
	{
		if (!this.HD_isAffectedByInjuries(_properties)) return;

		if (_hitInfo.BodyPart != ::Const.BodyPart.Head) return;

		// We wanna stay compatible with other effects (like Steelbrow or Through the Gaps), which might disable critical damage
		// So we do a quick&dirty check whether any critical damage exists in _hitInfo. If not, then we skip
		if (_hitInfo.BodyDamageMult == 1.0) return;

		_hitInfo.BodyDamageMult += this.m.HeadDamageMultPct;
		// Todo: Find out, why the DamageAgainstMult is correctly set to 2.0, but the fist to the head still onlny deals 8 damage, when it should deal 10-20
	}
});
