::Hardened.HooksMod.hook("scripts/skills/perks/perk_coup_de_grace", function(q) {
	q.m.DamageTotalMult <- 1.2;

	// Overwrite, because we utilize different conditions for granting the damage bonus
	q.onAnySkillUsed = @() function ( _skill, _targetEntity, _properties )
	{
		if (this.isSkillValid(_skill) && this.isTargetValid(_targetEntity))
		{
			_properties.DamageTotalMult *= this.m.DamageTotalMult;
		}
	}

	// Overwrite, because we no longer display an icon, when hitting someone while our effect is active. Instead the feedback only exists as a hit factor tooltip
	q.onBeforeTargetHit = @() function( _skill, _targetEntity, _hitInfo )
	{
	}

// MSU Functions
	// Overwrite, because even if Reforged had hitfactors, we display them under different conditions
	q.onGetHitFactors = @() function( _skill, _targetTile, _tooltip )
	{
		if (!this.isSkillValid(_skill)) return;
		if (!_targetTile.IsOccupiedByActor) return;
		if (!this.isTargetValid(_targetTile.getEntity())) return;

		_tooltip.push({
			icon = this.getIconColored(),
			text = this.getName(),
		});
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return true;	// The damage bonus is global
	}

	q.isTargetValid <- function( _target )
	{
		if (::MSU.isNull(_target)) return false;

		if (_target.getCurrentProperties().IsRooted) return true;
		if (_target.getSkills().hasSkillOfType(::Const.SkillType.TemporaryInjury)) return true;

		return false;
	}
});

