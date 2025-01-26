::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_polearm", function(q) {
// Public
	q.m.DisplacementHitChanceModifier <- 15;

	q.create = @(__original) function()
	{
		__original();
		this.m.Order = ::Const.SkillOrder.Last;		// We want to revert the vanilla AP reduction so our order must be very late
	}

	// Overwrite so Polearm Mastery no longer grants all reach weapons a discount
	q.onAfterUpdate = @() function( _properties )
	{
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (_skill.getID() == "actives.hook" || _skill.getID() == "actives.repel")
		{
			_properties.MeleeSkill += this.m.DisplacementHitChanceModifier;
		}
	}

// MSU Functions
	q.onGetHitFactors <- function( _skill, _targetTile, _tooltip )
	{
		if (this.isSkillValid(_skill))
		{
			_tooltip.push({
				icon = "ui/tooltips/positive.png",
				text = ::MSU.Text.colorPositive(this.m.DisplacementHitChanceModifier + "% ") + this.getName(),
			});
		}
	}

	q.onQueryTooltip <- function( _skill, _tooltip )
	{
		if (this.isSkillValid(_skill))
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has " + ::MSU.Text.colorizeValue(this.m.DisplacementHitChanceModifier, {AddSign = true, AddPercent = true}) + " [chance to hit|Concept.Hitchance]",
			});
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return (_skill.getID() == "actives.hook" || _skill.getID() == "actives.repel");
	}
});
