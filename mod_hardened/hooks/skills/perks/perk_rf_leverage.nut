::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_leverage", function(q) {
	// Public
	q.m.ActionPointModifierPerAlly <- -1;

	// Private
	q.m.IsSpent <- false;

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.m.IsSpent)
			return;

		local actor = this.getContainer().getActor();
		if (!actor.isPreviewing() || actor.getPreviewMovement() != null || !this.isSkillValid(actor.getPreviewSkill()))
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (this.isSkillValid(skill))
				{
					skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + this.getActionPointModifier());
				}
			}
		}
	}

	q.onAnySkillExecuted = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
	{
		__original(_skill, _targetTile, _targetEntity, _forFree);

		if (this.isSkillValid(_skill) && ::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			this.m.IsSpent = true;
		}
	}
	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsSpent = false;
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.IsSpent = true;
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (_skill.isRanged() || !_skill.isAttack())
			return false;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Polearm);
	}

	q.getActionPointModifier <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap())
		{
			return 0;
		}

		local adjacentAllies = ::Tactical.Entities.getAlliedActors(actor.getFaction(), actor.getTile(), 1, true).len();
		return adjacentAllies * this.m.ActionPointModifierPerAlly;
	}
});
