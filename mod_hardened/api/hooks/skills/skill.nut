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
	// Public
	q.m.IsHidingIconMini <- false;	// If set to true, then the IconMini will be treated as if it was an empty string and never display

	// Private
	q.m.HD_Temp_IsFree <- false;	// Ignore fatigue and action point cost during isAffordable check

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

	q.getIconMini = @(__original) function()
	{
		if (this.m.IsHidingIconMini)
		{
			return "";
		}
		else
		{
			return __original();
		}
	}

// Modular Vanilla Events
	q.onAttackEntityMissed = @(__original) function( _attackInfo )
	{
		::Hardened.Temp.LastAttackInfo = ::MSU.asWeakTableRef(_attackInfo);
		__original(_attackInfo);
	}

// New Getter
	// If we are evaluating _target, potentially targeting them with _usedSkill, how would that change the targets perceived value?
	// @return a non-negative float value
	q.getQueryTargetMultAsUser <- function( _target, _usedSkill = null )	// Const
	{
		return 1.0;
	}

	// If _user is evaluating our value, potentially targeting us with _usedSkill, how would that change our perceived value for them?
	// @return a non-negative float value
	q.getQueryTargetMultAsTarget <- function( _user, _usedSkill = null )	// Const
	{
		return 1.0;
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

	// This event is called when this entity is spawned and placed on the map.
	// It should be used in place of onCombatStarted to catch entities spawning mid battle
	q.onSpawned <- function()
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
		local isRootSkill = (::Hardened.Temp.RootSkillCounter == null);
		if (isRootSkill) ::Hardened.Temp.RootSkillCounter = ::Const.SkillCounter;	// Our execution is the beginning of a new chain. It was not the result of another skills delayed execution

		local container = this.getContainer();	// Some skills remove themselves during onUse, causing them to not being attached to their container anymore
		container.onReallyBeforeSkillExecuted(this, _targetTile);
		local ret = __original(_user, _targetTile);
		container.onReallyAfterSkillExecuted(this, _targetTile, ret);

		if (isRootSkill) ::Hardened.Temp.RootSkillCounter = null;	// Our initial execution has ended. But our RootSkillCounter might have been preserved in some scheduled delays
		return ret;
	}
});


