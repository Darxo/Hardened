::Hardened.HooksMod.hook("scripts/skills/perks/perk_backstabber", function(q) {
	// Public
	q.m.HitChancePerSurround <- 5;

	// Overwrite because we replace the vanilla effect with our own implementation
	q.onUpdate = @() function ( _properties ) {}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		if (this.isSkillValid(_skill) && _targetEntity != null)
		{
			_properties.MeleeSkill += this.getHitChanceModifier(_targetEntity);
			_properties.RangedSkill += this.getHitChanceModifier(_targetEntity);
		}
	}

// MSU Functions
	q.onGetHitFactors = @(__original) function( _skill, _targetTile, _tooltip )
	{
		__original(_skill, _targetTile, _tooltip);

		if (!this.isSkillValid(_skill)) return;
		if (!_targetTile.IsOccupiedByActor) return;

		local hitChanceModifier = this.getHitChanceModifier(_targetTile.getEntity());
		if (hitChanceModifier != 0)
		{
			_tooltip.push({
				icon = hitChanceModifier > 0 ? "ui/tooltips/positive.png" : "ui/tooltips/negative.png",
				text = ::MSU.Text.colorizeValue(hitChanceModifier, {AddPercent = true}) + " " + this.getName(),
			});
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return _skill.isUsingHitchance();
	}

	q.getHitChanceModifier <- function( _targetEntity )
	{
		local surroundedCount = _targetEntity.getSurroundedCount();	// This function already subtracts one, so we dont have to do it here
		return surroundedCount * this.m.HitChancePerSurround;
	}
});
