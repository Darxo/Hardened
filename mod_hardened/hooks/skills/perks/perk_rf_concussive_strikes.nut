::Hardened.wipeClass("scripts/skills/perks/perk_rf_concussive_strikes", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_concussive_strikes", function(q) {
	// Private
	q.m.CanSkillCauseShockwave <- false;	// Will be set to true before skill execution, when no Stun is present on the target

	q.onTargetKilled <- function( _targetEntity, _skill )
	{
		if (this.getContainer().getActor().isAlliedWith(_targetEntity)) return;

		if (_targetEntity.isPlacedOnMap() && this.isSkillValid(_skill))
		{
			this.triggerShockwave(_targetEntity.getTile());
		}
	}

// Hardened Events
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		if (_targetTile.IsOccupiedByActor && this.isSkillValid(_skill) && !_targetTile.getEntity().getSkills().hasSkill("effects.stunned"))
		{
			this.m.CanSkillCauseShockwave = true;
		}
	}

	q.onReallyAfterSkillExecuted <- function( _skill, _targetTile, _success )
	{
		if (this.m.CanSkillCauseShockwave && _targetTile.IsOccupiedByActor)
		{
			local targetEntity = _targetTile.getEntity();
			if (targetEntity.getSkills().hasSkill("effects.stunned"))	// The target might already be dead, but that shouldn't concern us. We still applied a stun, therefor triggering a shockwave
			{
				this.triggerShockwave(_targetTile);
			}
		}
		this.m.CanSkillCauseShockwave = false;
	}

// New Functions
	q.triggerShockwave <- function( _centreTile )
	{
		local actor = this.getContainer().getActor();
		local adjacentEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), _centreTile, 1, true);
		foreach (enemy in adjacentEnemies)
		{
			if (!enemy.getCurrentProperties().IsImmuneToDaze && !enemy.getSkills().hasSkill("effects.dazed"))
			{
				local effect = ::new("scripts/skills/effects/dazed_effect");
				enemy.getSkills().add(effect);
				effect.setTurns(1);
				if (!actor.isHiddenToPlayer() && enemy.getTile().IsVisibleForPlayer)
				{
					::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " dazes " + ::Const.UI.getColorizedEntityName(enemy) + " with a shockwave");
				}
			}
		}
	}

	q.isSkillValid <- function( _skill )
	{
		if (this.m.RequiredWeaponType == null) return true;

		if (_skill == null) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(this.m.RequiredWeaponType)) return false;

		return true;
	}
});
