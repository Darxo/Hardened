::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_dagger", function(q) {
	// Public
	q.m.HD_FatigueCostMult <- 0.75;
	q.m.WeightThreshold <- 10;	// Offhand item must weigh less than this to be eligible for free use

	// Private
	q.m.IsSpent <- true;	// Has the free offhand item use already been spent?
	q.m.LastExecutedSkillForFree <- false;	// Temp: so that we know, whether the last executed skill was for free

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

	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
		__original(_skill, _targetTile);

		if (this.m.IsSpent) return;
		if (this.m.LastExecutedSkillForFree) return;
		if (!this.isEnabled()) return;

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
		local actor = this.getContainer().getActor();
		if (!actor.isActiveEntity()) return;

		local weapon = actor.getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Dagger))
		{
			return false;
		}

		return true;
	}

	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Dagger)) return false;

		return true;
	}
});
