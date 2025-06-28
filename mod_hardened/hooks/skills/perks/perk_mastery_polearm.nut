::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_polearm", function(q) {
	// Public
	q.m.DisplacementHitChanceModifier <- 15;
	q.m.HD_FatigueCostMult <- 0.75;

	q.create = @(__original) function()
	{
		__original();
		this.m.Order = ::Const.SkillOrder.Last;		// We want to revert the vanilla AP reduction so our order must be very late
	}

	// Overwrite so Polearm Mastery no longer grants all reach weapons a discount
	q.onAfterUpdate = @() function( _properties )
	{
		// Feat: We now implement the fatigue cost discount of masteries within the mastery perk
		if (this.m.HD_FatigueCostMult != 1.0)
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (this.isSkillValid(skill))
				{
					skill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;
				}
			}
		}
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (this.isValidDisplacementSkill(_skill))
		{
			_properties.MeleeSkill += this.m.DisplacementHitChanceModifier;
		}
	}

// MSU Functions
	q.onGetHitFactors <- function( _skill, _targetTile, _tooltip )
	{
		if (this.isValidDisplacementSkill(_skill))
		{
			_tooltip.push({
				icon = "ui/tooltips/positive.png",
				text = ::MSU.Text.colorPositive(this.m.DisplacementHitChanceModifier + "% ") + this.getName(),
			});
		}
	}

	q.onQueryTooltip <- function( _skill, _tooltip )
	{
		if (this.isValidDisplacementSkill(_skill))
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has " + ::MSU.Text.colorizeValue(this.m.DisplacementHitChanceModifier, {AddSign = true, AddPercent = true}) + ::Reforged.Mod.Tooltips.parseString(" [chance to hit|Concept.Hitchance]"),
			});
		}
	}

// New Functions
	q.isValidDisplacementSkill <- function( _skill )
	{
		if (!this.isSkillValid(_skill)) return false;
		return (_skill.getID() == "actives.hook" || _skill.getID() == "actives.repel");
	}

	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Polearm)) return false;

		return true;
	}
});
