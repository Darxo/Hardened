::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_sword", function(q) {
	// Overwrite because sword mastery no longer grants Passing Step
	q.onAdded = @() function() {}
	q.onRemoved = @() function() {}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;
		if (!this.isEnemyValid(_targetEntity)) return;

		_targetEntity.getSkills().add(::new("scripts/skills/effects/hd_disrupted_flow_effect"));
	}

	q.onTargetMissed = @(__original) function( _skill, _targetEntity )
	{
		__original(_skill, _targetEntity);

		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;
		if (!this.isEnemyValid(_targetEntity)) return;

		_targetEntity.getSkills().add(::new("scripts/skills/effects/hd_disrupted_flow_effect"));
	}

// MSU Functions
	q.onGetHitFactors = @(__original) function( _skill, _targetTile, _tooltip )
	{
		__original(_skill, _targetTile, _tooltip);

		if (!_targetTile.IsOccupiedByActor) return;
		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;
		if (!this.isEnemyValid(_targetTile.getEntity())) return;

		_tooltip.push({
			icon = "ui/icons/initiative.png",
			text = this.getName(),
		});
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
		return _skill.isAttack();
	}

	// Is the enemy valid for our initiative debuff effect?
	q.isEnemyValid <- function( _enemy )
	{
		if (::MSU.isNull(_enemy) || !_enemy.isAlive() || _enemy.isDying()) return false;
		if (_enemy.isAlliedWith(this.getContainer().getActor())) return false;

		return _enemy.isTurnStarted();
	}
});
