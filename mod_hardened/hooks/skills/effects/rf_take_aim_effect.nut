::Hardened.HooksMod.hook("scripts/skills/effects/rf_take_aim_effect", function(q) {#
	// Public
	q.m.HD_FatigueCostMult <- 0.0;		// Cross Attacks cost no fatigue while under the effect of take aim
	q.m.HD_FirearmMaxRangeModifier <- 1;

	// Overwrite, because we delete and change too many tooltips
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		if (this.m.HD_FatigueCostMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Crossbow and Firearm Attacks cost " + ::MSU.Text.colorizeMultWithText(this.m.HD_FatigueCostMult, {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Fatigue|Concept.Fatigue]"),
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = ::Reforged.Mod.Tooltips.parseString("Crossbows Attacks will never hit the [Cover|Concept.Cover] and cannot go astray"),
		});

		if (this.m.HD_FirearmMaxRangeModifier != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Firearm Attacks have " + ::MSU.Text.colorizeValue(this.m.HD_FirearmMaxRangeModifier, {AddSign = true}) + " Maximum Range",
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("Will expire when you attack or end your [turn|Concept.Turn]"),
		});

		return ret;
	}

	// Overwrite, because we apply completely different effects from Reforged
	q.onAfterUpdate = @() function( _properties )
	{
		foreach (_activeSkill in this.getContainer().getActor().getSkills().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (this.isSkillValidForCrossbow(_activeSkill))
			{
				_activeSkill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;
			}

			if (this.isSkillValidForFirearm(_activeSkill))
			{
				_activeSkill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;
				_activeSkill.m.MaxRange += this.m.HD_FirearmMaxRangeModifier;	// Reforged only adds this for handgonnes
			}
		}
	}

// New Functions
	q.isSkillValidForCrossbow <- function( _skill )
	{
		if (!_skill.isAttack()) return false;

		local item = _skill.getItem();
		if (::MSU.isNull(item)) return false;
		if (!item.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!item.isWeaponType(::Const.Items.WeaponType.Crossbow)) return false;

		return true;
	}

	q.isSkillValidForFirearm <- function( _skill )
	{
		if (!_skill.isAttack()) return false;

		local item = _skill.getItem();
		if (::MSU.isNull(item)) return false;
		if (!item.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!item.isWeaponType(::Const.Items.WeaponType.Firearm)) return false;

		return true;
	}
});
