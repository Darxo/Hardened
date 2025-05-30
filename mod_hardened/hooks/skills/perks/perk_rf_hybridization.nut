::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_hybridization", function(q) {	// This has been renamed into "Toolbox"
	// Public
	q.m.AdditionalBagSlots <- 1;
	q.m.ThrowingSpearShieldDamageMult <- 2.0;

	q.create = @(__original) function()
	{
		__original();
		this.m.RangedSkillToMeleeMult = 0.0;	// In Reforged this is 0.1
		this.m.MeleeSkillToRangedMult = 0.0;	// In Reforged this is 0.2
	}

	// Overwrite because we no longer grant melee defense
	q.onUpdate = @() function( _properties )
	{
		// This perk does not work, while the character has weapon master to prevent item slots changing during combat
		if (!this.getContainer().hasSkill("perk.rf_weapon_master"))
		{
			_properties.BagSlots += this.m.AdditionalBagSlots;
		}

		_properties.MeleeSkill += this.getMeleeBonus();
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (_skill.getID() == "actives.throw_spear")
		{
			_properties.ShieldDamageMult *= this.m.ThrowingSpearShieldDamageMult;
		}
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		if (!_targetEntity.isAlive() || !this.isSkillValid(_skill))
			return;

		this.applyHitEffect(_skill, _targetEntity, _bodyPart)
	}

	q.onTargetMissed = @(__original) function( _skill, _targetEntity )
	{
		__original(_skill, _targetEntity);
		if (_targetEntity.isAlive() && this.isSkillValid(_skill) && _skill.getDamageType().contains(::Const.Damage.DamageType.Cutting))
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/overwhelmed_effect"));
		}
	}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsSpent = true;	// IsSpent now stays always stays on true to disable swapping and hide the effect icon
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;		// We must be the _user
		if (_user.getID() != _target.getID()) return ret;		// _user and _target must not be the same

		if (_skill == null || this.isSkillValid(_skill)) return ret;

		if (_skill.getDamageType().contains(::Const.Damage.DamageType.Blunt) && _target.getSkills().hasSkill("effects.staggered") && !_target.getSkills().hasSkill("effects.stunned"))
		{
			ret *= 1.5;		// We strongly prefer to target enemies that are staggered, but not yet stunned
		}

		return ret;
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

				staggeredEffect.m.TurnsLeft = 1;	// Hidden effect, to prevent chain stuns
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
