::Hardened.Temp.LastUsedSkill <- null;		// This is used to be able to calculate shield damage multipliers during the applyShieldDamage function
::Hardened.Temp.LastUsedSkillOwner <- null;	// This is used to be able to calculate shield damage multipliers during the applyShieldDamage function

// The last target/skill/user of the onScheduledTargetHit or getExpectedDamage function
// This is only used in the getHitchance function from character.nut to predict the headshot chance more accurately
::Hardened.Temp.TargetToBeHit <- null;
::Hardened.Temp.SkillToBeHitWith <- null;
::Hardened.Temp.UserWantingToHit <- null;

// Modular Vanilla Temp Variables
::Hardened.Temp.LastAttackInfo <- null;		// weakref to the last AttackInfo created. Usually only useful to have access to it during onTargetMissed or onMissed calls

::Hardened.HooksMod.hook("scripts/skills/skill", function(q) {
	q.m.HD_Temp_IsFree <- false;	// Ignore fatigue and action point cost during isAffordable check

	q.isDuelistValid = @() function()
	{
		local mainhandItem = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (mainhandItem == null) return false;
		if (mainhandItem.isItemType(::Const.Items.ItemType.OneHanded) == false) return false;

		return true;
	}

	q.isAffordable = @(__original) function()
	{
		if (this.m.HD_Temp_IsFree) return true;	// Allows us to do a vanilla isUsableOn check without considering the cost. Useful for triggering other characters skills
		return __original();
	}

	q.use = @(__original) function( _targetTile, _forFree = false )
	{
		::Hardened.Temp.LastUsedSkill = ::MSU.asWeakTableRef(this);		// We can expect the skill to exist long enough, even if it is removed from the actor, usually within delayed events
		::Hardened.Temp.LastUsedSkillOwner = ::MSU.asWeakTableRef(this.getContainer().getActor());	// The skill might not have an owner anymore by that time, e.g. with Throwing Spear skill

		return __original(_targetTile, _forFree);
	}

	q.getHitFactors = @(__original) function( _targetTile )
	{
		local ret = __original(_targetTile);

		// New Entries
		if (_targetTile.IsOccupiedByActor)
		{
			local target = _targetTile.getEntity();
			local properties = this.m.Container.buildPropertiesForUse(this, target);

			// Headshot chance
			if (this.isAttack())
			{
				local headshotChance = properties.getHeadHitchance(::Const.BodyPart.Head, this.getContainer().getActor(), this, target);
				ret.insert(0, {
					icon = "ui/icons/chance_to_hit_head.png",
					text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(headshotChance, {AddPercent = true}) + " headshot chance"),
				});
			}
		}

		return ret;
	}

	/* This change will make it so both, armor and health damage use the exact same base damage roll
	 * No longer is it possible to low-roll on armor damage and high-roll on the hightpoint damage part.
	 * This is only confusing when trying to understand the damage dealt in combat and can create additional frustration
	 */
	q.onScheduledTargetHit = @(__original) function( _info )
	{
		if (!_info.TargetEntity.isAlive())
		{
			return __original(_info);
		}

		local oldMathRand = ::Math.rand;

		local endSwitcheroo = function()
		{
			::Math.rand = oldMathRand;
		}

		local startSwitcheroo = function()
		{
			local previosResult = null;
			local prevMax = null;

			// We will encounter ::Math.rand in this switcheroo operation exactly two times
			::Math.rand = function( _min = null, _max = null )
			{
				if (_min == null && _max == null) return oldMathRand();

				if (previosResult == null)	// First time we need to note the min and max range for the base values
				{
					previosResult = oldMathRand(_min, _max);
				}

				return previosResult;	// We now return the same roll in both situations
			}

			// Exit Plant
			local oldMax = ::Math.max;
			::Math.max = function( _a, _b )
			{
				endSwitcheroo();
				local ret = oldMax(_a, _b);
				::Math.max = oldMax;	// Revert Plant
				return ret;
			}
		}

		// Entry Plant
		local oldGetHitChance = _info.Properties.getHitchance;
		_info.Properties.getHitchance = function( _bodyPart )
		{
			startSwitcheroo();
			local ret = oldGetHitChance(_bodyPart);
			_info.Properties.getHitchance = oldGetHitChance;	// Revert Plant
			return ret;
		}

		// We save the target skill and user of the last scheduled hit.
		// This conflicts a bit with getExpectedDamage but both functions should not be called intertwined
		// That way any headshot chance during this call will be calculated with the target in mind
		::Hardened.Temp.TargetToBeHit = ::MSU.asWeakTableRef(_info.TargetEntity);
		::Hardened.Temp.SkillToBeHitWith = ::MSU.asWeakTableRef(_info.Skill);
		::Hardened.Temp.UserWantingToHit = ::MSU.asWeakTableRef(_info.User);

		__original(_info);

		// future headshot chance calculations not be influenced by this
		::Hardened.Temp.TargetToBeHit = null;
		::Hardened.Temp.SkillToBeHitWith = null;
		::Hardened.Temp.UserWantingToHit = null;
	}

	q.getExpectedDamage = @(__original) function( _target )
	{
		// We save the target, skill and user of the last expected damage calculation call.
		// This conflicts a bit with onScheduledTargetHit but both functions should not be called intertwined
		// That way any headshot chance during this call will be calculated with the target in mind
		::Hardened.Temp.TargetToBeHit = ::MSU.asWeakTableRef(_target);
		::Hardened.Temp.SkillToBeHitWith = ::MSU.asWeakTableRef(this);
		::Hardened.Temp.UserWantingToHit = ::MSU.asWeakTableRef(this.getContainer().getActor());

		local ret = __original(_target);

		// future headshot chance calculations not be influenced by this
		::Hardened.Temp.TargetToBeHit = null;
		::Hardened.Temp.SkillToBeHitWith = null;
		::Hardened.Temp.UserWantingToHit = null;

		return ret;
	}
// Modular Vanilla Functions
	q.onAttackEntityMissed = @(__original) function( _attackInfo )
	{
		::Hardened.Temp.LastAttackInfo = ::MSU.asWeakTableRef(_attackInfo);
		__original(_attackInfo);
	}

// New Events
	q.onOtherSkillAdded <- function( _skill )
	{
	}

	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
	}

	// This event is only called directly after a skills
	q.onReallyAfterSkillExecuted <- function( _skill, _targetTile, _success )
	{
	}

	// if _attacker is null then _defenderProps is just the currentProperties of the defender
	q.onBeforeShieldDamageReceived <- function( _damage, _shield, _defenderProps, _attacker = null, _attackerProps = null, _skill = null )
	{
	}

	// Beware at this point, this shield might be "broken", aka unequipped
	q.onAfterShieldDamageReceived <- function( _initialDamage, _damageReceived, _shield, _attacker = null, _skill = null )
	{
	}
});

::Hardened.HooksMod.hookTree("scripts/skills/skill", function(q) {
	q.onAdded = @(__original) function()
	{
		__original();
		this.getContainer().onOtherSkillAdded(this);
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local container = this.getContainer();	// Some skills remove themselves during onUse, causingthem to not being attached to their container anymore
		container.onReallyBeforeSkillExecuted(this, _targetTile);
		local ret = __original(_user, _targetTile);
		container.onReallyAfterSkillExecuted(this, _targetTile, ret);
		return ret;
	}
});


