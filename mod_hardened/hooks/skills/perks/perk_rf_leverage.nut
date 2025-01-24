::Hardened.wipeClass("scripts/skills/perks/perk_rf_leverage");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_leverage", function(q) {
	// Public
	q.m.ActionPointModifierPerAlly <- -1;

	// Private
	q.m.IsSpent <- false;

	q.create <- function()
	{
		this.m.ID = "perk.rf_leverage";
		this.m.Name = ::Const.Strings.PerkName.RF_Leverage;
		this.m.Description = ::Const.Strings.PerkDescription.RF_Leverage;
		this.m.Icon = "ui/perks/perk_rf_leverage.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.onAfterUpdate <- function( _properties )
	{
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

	q.onAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.isSkillValid(_skill) && this.getContainer().getActor().isActiveEntity())
		{
			this.m.IsSpent = true;
		}
	}
	q.onTurnStart <- function()
	{
		this.m.IsSpent = false;
	}

	q.onCombatFinished <- function()
	{
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
