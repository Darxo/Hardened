::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_dagger", function(q) {
	// Public
	q.m.WeightThreshold <- 10;	// Offhand item must weigh less than this to be eligable for free use

	// Private
	q.m.IsSpent <- true;	// Has the free offhand item use already been spent?
	q.m.LastExecutedSkillForFree <- false;	// Temp: so that we know, whether the last executed skill was for free

	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
		__original(_skill, _targetTile);

		if (this.m.IsSpent) return;
		if (this.m.LastExecutedSkillForFree) return;
		if (!this.isEnabled()) return;
		if (!::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))	return;

		if (!::MSU.isNull(_skill.getItem()) && ::MSU.isEqual(_skill.getItem(), this.getContainer().getActor().getOffhandItem()))
		{
			this.m.IsSpent = true;
		}
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.m.IsSpent) return;
		if (!this.isEnabled()) return;

		local offhand = this.getContainer().getActor().getOffhandItem();
		if (offhand != null && offhand.getWeight() < this.m.WeightThreshold)
		{
			foreach (skill in offhand.getSkills())
			{
				skill.m.ActionPointCost = 0;
			}
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
		this.skill.onCombatFinished();
		this.m.IsSpent = true;
	}

// MSU Events
	q.onBeforeAnySkillExecuted = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
	{
		__original(_skill, _targetTile, _targetEntity, _forFree);
		this.m.LastExecutedSkillForFree = _forFree;
	}

// New Functions
	q.isEnabled <- function()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Dagger))
		{
			return false;
		}

		return true;
	}
});
