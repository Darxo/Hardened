::Hardened.wipeClass("scripts/skills/perks/perk_rf_leverage", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_leverage", function(q) {
	// Public
	q.m.ActionPointModifierPerAlly <- -1;

	// Private
	q.m.IsSpent <- false;

	q.onAfterUpdate <- function( _properties )
	{
		if (this.m.IsSpent) return;

		local actor = this.getContainer().getActor();
		// If we are previewing a skill, which would use up our Leverage charge, we stop applying this bonus
		if (actor.isPreviewing() && actor.getPreviewSkill() != null && this.isSkillValid(actor.getPreviewSkill())) return;

		local customOrigin = null;
		if (actor.isPreviewing() && actor.getPreviewMovement() != null)
		{
			// If we are previewing movement, we instead want the discount depending on the destination tile
			customOrigin = actor.getPreviewMovement().End;
		}
		local actionPointModifier = this.getActionPointModifier(customOrigin);

		foreach (skill in this.getContainer().m.Skills)
		{
			if (this.isSkillValid(skill))
			{
				skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + actionPointModifier);
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

	/// @param _pointOfOrigin custom tile position for which we calculate the action point modifier for
	/// 	If null, the position of this actor will be used instead
	q.getActionPointModifier <- function( _pointOfOrigin = null )
	{
		local actor = this.getContainer().getActor();
		if (_pointOfOrigin == null)
		{
			if (!actor.isPlacedOnMap()) return 0;
			_pointOfOrigin = actor.getTile();
		}

		local adjacentAllies = ::Tactical.Entities.getAlliedActors(actor.getFaction(), _pointOfOrigin, 1, true);
		foreach (ally in adjacentAllies)
		{
			if (ally.getID() == actor.getID())	// During previewing we otherwise accidentally count ourselves
			{
				return (adjacentAllies.len() - 1) * this.m.ActionPointModifierPerAlly
			}
		}

		return adjacentAllies.len() * this.m.ActionPointModifierPerAlly;
	}
});
