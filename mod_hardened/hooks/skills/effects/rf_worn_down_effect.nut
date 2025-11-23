::Hardened.HooksMod.hook("scripts/skills/effects/rf_worn_down_effect", function(q) {
	q.m.MeleeDefenseMult <- 0.7;
	q.m.RangedDefenseMult <- 0.7;
	q.m.NonAttackFatigueMult <- 1.5;

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

		if (this.m.RangedDefenseMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::MSU.Text.colorizeMultWithText(this.m.RangedDefenseMult) + ::Reforged.Mod.Tooltips.parseString(" [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::Reforged.Mod.Tooltips.parseString("Non-Attack skills cost " + ::MSU.Text.colorizeMultWithText(this.m.NonAttackFatigueMult, {InvertColor = true}) + " [Fatigue|Concept.Fatigue]"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the end of your [turn|Concept.Turn]"),
		});

		return ret;
	}

	// Overwrite because we completely replace reforged effects
	q.onUpdate = @() function( _properties )
	{
		_properties.MeleeDefenseMult *= this.m.MeleeDefenseMult;
		_properties.RangedDefenseMult *= this.m.RangedDefenseMult;
	}

	q.onAfterUpdate <- function( _properties )
	{
		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (!skill.isAttack())
			{
				skill.m.FatigueCostMult *= this.m.NonAttackFatigueMult;
			}
		}
	}
});
