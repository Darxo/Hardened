::Hardened.wipeClass("scripts/skills/perks/perk_rf_entrenched", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_mauler", function(q) {
	// Public
	q.m.RecoveredActionPointsMovement <- 3;

	// Private
	q.m.HD_IsMovementBonusGained <- false;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "The wounded are weakest!";
		this.m.Icon = "ui/perks/perk_rf_sanguinary.png";	// The art for Sanguinary fits better for this rework
		this.addType(::Const.SkillType.StatusEffect);	// We add StatusEffect so that this perk can produce a status effect icon
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (!this.m.HD_IsMovementBonusGained)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString(format("Recover %s [Action Points|Concept.ActionPoints] the next time you move next to an injured enemy during your [turn|Concept.Turn]", ::MSU.Text.colorizeValue(this.m.RecoveredActionPointsMovement))),
			});
		}

		if (!this.isEnabled())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Requires a Cleaver in your Mainhand",
			});
		}

		return ret;
	}

	q.isHidden = @(__original) function()
	{
		return this.m.HD_IsMovementBonusGained;
	}

	q.onMovementFinished = @(__original) function()
	{
		__original();

		if (!this.isEnabled()) return;

		local actor = this.getContainer().getActor();
		if (!this.m.HD_IsMovementBonusGained && this.getInjuredEnemyAmount(actor.getTile()) > 0)
		{
			this.m.HD_IsMovementBonusGained = true;
			actor.recoverActionPoints(this.m.RecoveredActionPointsMovement);
			this.spawnIcon("perk_rf_sanguinary", actor.getTile());
		}
	}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.HD_IsMovementBonusGained = false;
	}

// New Private Functions
	q.isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isDisarmed()) return false;

		local weapon = actor.getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Cleaver)) return false;

		return true;
	}

	q.getInjuredEnemyAmount <- function( _tile )
	{
		local adjacentEnemies = ::Tactical.Entities.getHostileActors(this.getContainer().getActor().getFaction(), _tile, 1, true);
		local injuredEnemies = 0;
		foreach (enemy in adjacentEnemies)
		{
			if (enemy.getSkills().hasSkillOfType(::Const.SkillType.TemporaryInjury))
			{
				injuredEnemies++;
			}
		}
		return injuredEnemies;
	}





	q.m.ArmorPenetrationModifier <- 0.15;
	q.m.BleedStacksOnHigherResolve <- 1;
	q.m.BleedStacksOnHigherInitiative <- 1;

	q.create = @(__original) function()
	{
		__original();

		this.m.RequiredDamageType = null;	// We allow any damage type, as long as it comes from a cleaver
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (this.isSkillValid(_skill) && this.isTargetValidForPenetration(_targetEntity))
		{
			_properties.DamageDirectAdd += this.m.ArmorPenetrationModifier;
		}
	}

	// We need to compare initiative and resolve before the skill is really executed, because
	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		if (!_targetEntity.isAlive()) return;

		if (_targetEntity.getCurrentProperties().IsImmuneToBleeding) return;
		if (_damageInflictedHitpoints < ::Const.Combat.MinDamageToApplyBleeding) return;
		if (!this.isSkillValid(_skill)) return;

		if (this.isTargetValidForInitiativeBleed(_targetEntity))
		{

		}
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));
		}
	};

	// Overwrite to remove the effect of Reforged
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;		// We must be the _user
		if (_user.getID() != _target.getID()) return ret;		// _user and _target must not be the same

		if (_skill != null && this.isSkillValid(_skill) && _target.getHitpointsPct() >= this.m.TargetHealthThreshold)
		{
			ret *= 1.2;
		}

		return ret;
	}

// MSU Functions
	q.onGetHitFactors = @(__original) function( _skill, _targetTile, _tooltip )
	{
		if (_targetTile.IsOccupiedByActor && this.isSkillValid(_skill) && _targetTile.getEntity().getHitpointsPct() >= this.m.TargetHealthThreshold)
		{
			_tooltip.push({
				icon = "ui/tooltips/positive.png",
				text = ::MSU.Text.colorPositive(this.getName()),
			});
		}
	}

// New Functions
	q.isTargetValidForPenetration <- function( _targetEntity )
	{
		return !_targetEntity.getSkills().hasSkill("effects.bleeding");
	}

	q.isTargetValidForResolveBleed <- function( _targetEntity )
	{
		return _targetEntity.getBravery() < this.getContainer().getActor().getBravery();
	}

	q.isTargetValidForInitiativeBleed <- function( _targetEntity )
	{
		return _targetEntity.getInitiative() < this.getContainer().getActor().getInitiative();
	}
});
