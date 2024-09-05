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

	/* This change will make it so both, armor and health damage use the exact same base damage roll
	 * No longer is it possible to low-roll on armor damage and high-roll on the hightpoint damage part.
	 * This is only confusing when trying to understand the damage dealt in combat and can create additional frustration
	 */
	q.onScheduledTargetHit = @(__original) function( _info )
	{
		if (!_info.TargetEntity.isAlive())
		{
			return __original(_info);;
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

		__original(_info);
	}

// New Functions
	q.onOtherSkillAdded <- function( _skill )
	{
	}
});

::Hardened.HooksMod.hookTree("scripts/skills/skill", function(q) {
	q.onAdded = @(__original) function()
	{
		__original();
		this.getContainer().onOtherSkillAdded(this);
	}
});


