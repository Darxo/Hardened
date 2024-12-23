::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_hybridization", function(q) {
	q.m.ThrowingSpearShieldDamageMult <- 1.5;

	q.create = @(__original) function()
	{
		__original();
		this.m.RangedSkillToMeleeMult = 0.15;	// In Reforged this is 0.10
	}

	// Overwrite because we no longer grant melee defense
	q.onUpdate = @() function( _properties )
	{
		_properties.MeleeSkill += this.getMeleeBonus();
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		_properties.ShieldDamageMult *= this.m.ThrowingSpearShieldDamageMult;
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		if (!_targetEntity.isAlive() || !this.isSkillValid(_skill))
			return;

		this.applyHitEffect(_skill, _targetEntity, _bodyPart)
	}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsSpent = true;	// IsSpent now stays always stays on true to disable swapping and hide the effect icon
	}

// Reforged Functions
	q.getRangedBonus = @() function()
	{
		return 0;	// This skill no longer provides Ranged Skill
	}

	// Overwrite because reforge has a small bug. But fixing that buf in reforged introduces a bigger issue
	q.isSkillValid = @() function( _skill )
	{
		if (!_skill.isRanged() || !_skill.isAttack())
			return false;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Throwing);
	}

// New Functions
	// This implementation is mostly a copy of REforged mastery implementation
	q.applyHitEffect <- function( _skill, _targetEntity, _bodyPart )
	{
		local actor = this.getContainer().getActor();
		if (_skill.getDamageType().contains(::Const.Damage.DamageType.Blunt))
		{
			local staggeredEffect = _targetEntity.getSkills().getSkillByID("effects.staggered");
			if (staggeredEffect != null)
			{
				if (_targetEntity.getCurrentProperties().IsImmuneToStun) return;

				local effect = ::new("scripts/skills/effects/stunned_effect");
				_targetEntity.getSkills().add(effect);
				effect.m.TurnsLeft = 1;
				if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " has stunned " + ::Const.UI.getColorizedEntityName(_targetEntity) + " for " + effect.m.TurnsLeft + " turn");
				}
			}
			else if (_bodyPart == ::Const.BodyPart.Head)
			{
				local effect = ::new("scripts/skills/effects/staggered_effect");
				_targetEntity.getSkills().add(effect);
				effect.m.TurnsLeft = 1;
				if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " has staggered " + ::Const.UI.getColorizedEntityName(_targetEntity) + " for " + effect.m.TurnsLeft + " turn");
				}
			}
		}
		else if (_skill.getDamageType().contains(::Const.Damage.DamageType.Piercing))
		{
			if (_bodyPart == ::Const.BodyPart.Body)	// This condition is different from reforged
			{
				local effect = ::new("scripts/skills/effects/rf_arrow_to_the_knee_debuff_effect");
				_targetEntity.getSkills().add(effect);
				if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " has impaled " + ::Const.UI.getColorizedEntityName(_targetEntity) + " for " + effect.m.TurnsLeft + " turns");
				}
			}
		}
		else if (_skill.getDamageType().contains(::Const.Damage.DamageType.Cutting))
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/overwhelmed_effect"));
		}
	}
});
