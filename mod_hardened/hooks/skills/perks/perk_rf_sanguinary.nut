::Hardened.wipeClass("scripts/skills/perks/perk_rf_sanguinary", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_sanguinary", function(q) {
	// Public
	q.m.AdditionalBleedStacks <- 5;		// This many additional bleed stacks are applied by this perk on an non-AoE attack

	// Private
	q.m.PreviousBleedStackSize <- null;		// Saves the amount of bleed stacks that were on the target before our attack hits them; If null, then there was no onBeforTargetHit event

	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "ui/perks/perk_rf_mauler.png";	// The art for Mauler fits better for this rework
		this.removeType(::Const.SkillType.StatusEffect);	// We no longer want to disaply a effect tooltip for this perk
	}

	q.onBeforeTargetHit = @(__original) function( _skill, _targetEntity, _hitInfo )
	{
		__original(_skill, _targetEntity, _hitInfo);
		this.m.PreviousBleedStackSize = this.getBleedStacks(_targetEntity);
	}

	q.onReallyAfterSkillExecuted = @(__original) function( _skill, _targetTile, _success )
	{
		__original(_skill, _targetTile, _success);

		if (!_success) return;
		if (!this.isSkillValid(_skill)) return;

		if (!_targetTile.IsOccupiedByActor) return;
		local targetEntity = _targetTile.getEntity();
		if (!targetEntity.isAlive()) return;

		if (this.m.PreviousBleedStackSize == null) return;
		if (this.getBleedStacks(targetEntity) <= this.m.PreviousBleedStackSize) return;

		this.m.PreviousBleedStackSize = null;
		for (local i = 1; i <= this.m.AdditionalBleedStacks; ++i)
		{
			targetEntity.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));
		}
	}

// New Private Functions
	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isAttack()) return false;
		if (_skill.isAOE()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Cleaver)) return false;

		return true;
	}

	q.getBleedStacks <- function( _actor )
	{
		local bleedSkill = _actor.getSkills().getSkillByID("effects.bleeding");
		if (bleedSkill == null) return 0;

		return bleedSkill.m.Stacks;
	}
});
