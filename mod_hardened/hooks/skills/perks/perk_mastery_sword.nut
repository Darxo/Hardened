::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_sword", function(q) {
	// Public
	q.m.HD_FatigueCostMult <- 0.75;

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);
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

	// Overwrite because sword mastery no longer grants Passing Step
	q.onAdded = @() function() {}
	q.onRemoved = @() function() {}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

		if (this.isSkillValidForDisruption(_skill, _targetEntity))
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/hd_disrupted_flow_effect"));
		}
	}

	q.onTargetMissed = @(__original) function( _skill, _targetEntity )
	{
		__original(_skill, _targetEntity);

		if (this.isSkillValidForDisruption(_skill, _targetEntity))
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/hd_disrupted_flow_effect"));
		}
	}

// MSU Functions
	q.onGetHitFactors = @(__original) function( _skill, _targetTile, _tooltip )
	{
		__original(_skill, _targetTile, _tooltip);

		if (_targetTile.IsOccupiedByActor && this.isSkillValidForDisruption(_skill, _targetTile.getEntity()))
		{
			_tooltip.push({
				icon = "ui/icons/initiative.png",
				text = this.getName(),
			});
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isDisarmed()) return false;

		local weapon = actor.getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Sword)) return false;

		return true;
	}

	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Sword)) return false;

		return true;
	}

	// Decides, whether _skill is valid to inflict disrupted_flow debuff onto _target
	q.isSkillValidForDisruption <- function( _skill, _target )
	{
		if (!this.isEnabled()) return false;
		if (!this.isSkillValid(_skill)) return false;
		if (!_skill.isAttack()) return false;
		if (!this.isEnemyValid(_target)) return false;

		return true;
	}

	// Is the enemy valid for our initiative debuff effect?
	q.isEnemyValid <- function( _enemy )
	{
		if (::MSU.isNull(_enemy) || !_enemy.isAlive() || _enemy.isDying()) return false;
		if (_enemy.isAlliedWith(this.getContainer().getActor())) return false;

		return _enemy.isTurnStarted();
	}
});
