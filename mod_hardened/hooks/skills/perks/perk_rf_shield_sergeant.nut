/// Hook knock_back so that it can be used on empty tiles
/// Will do nothing, if _knockBackSkill was already adjusted before
/// If shield_sergeant perk is removed, this adjustment will remain, until the skill is reset (reequipping shield or reloading save)
local hookKnockBack = function( _knockBackSkill )
{
	if ("HD_IsShieldSergeantHooked" in _knockBackSkill.m) return;	// This skill is already hooked
	_knockBackSkill.m.HD_IsShieldSergeantHooked <- true;

	local oldOnVerifyTarget = _knockBackSkill.onVerifyTarget;
	_knockBackSkill.onVerifyTarget = function( _user, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
		{
			return true;	// Even tiles blocked by obstacles or 2 levels higher are allowed. However vanilla does not highlight them correctly. This is an easter egg
		}

		return oldOnVerifyTarget(_user, _targetTile);
	}

	local oldOnuse = _knockBackSkill.onUse;
	_knockBackSkill.onUse = function( _user, _targetTile )
	{
		if (_targetTile.IsOccupiedByActor)
		{
			return oldOnuse(_user, _targetTile);
		}

		// Fluff: We place a hit-sound when using it on environment
		if (!_targetTile.IsEmpty || _targetTile.Level >= _user.getTile().Level + 2)		// Our knock back hits something solid
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), ::Const.Sound.Volume.Skill, _user.getPos());
		}
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " demonstrates how to use " + this.getName());

		return true;
	}
}

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_shield_sergeant", function(q) {
	// Public
	q.m.FreeUseTileDistance <- 3;

	// Private
	q.m.ExecutionDelay <- 150;	// Delay between every execution in milliseconds

	q.getTooltip = @(__original) function()
	{
		local ret = __original()

		foreach (index, entry in ret)
		{
			if (entry.id == 12)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Will expire upon [Recover|Skill+recover] or getting [stunned|Skill+stunned_effect], rooted, or [staggered|Skill+staggered_effect]");
				break;
			}
		}

		return ret;
	}

	q.onAnySkillExecuted = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
	{
		__original(_skill, _targetTile, _targetEntity, _forFree);

		// In order to prevent loops with other shield sergeants, this user must be the active entity
		local actor = this.getContainer().getActor();
		if (actor.isActiveEntity() && this.isSkillValid(_skill))
		{
			local potentialAllies = [];
			foreach (ally in ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), this.m.FreeUseTileDistance))
			{
				if (ally.getID() == actor.getID()) continue;
				potentialAllies.push(ally);
			}
			::MSU.Array.shuffle(potentialAllies);	// We want the execution order to be random

			::Time.scheduleEvent(::TimeUnit.Virtual, this.m.ExecutionDelay, this.triggerCopycat, {
				Self = this,
				SkillID = _skill.getID(),
				RemainingAllies = potentialAllies,
			});
		}
	}

	q.onAfterUpdate <- function( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap())
		{
			foreach (activeSkill in actor.getSkills().getAllSkillsOfType(::Const.SkillType.Active))
			{
				// By checking for MaxRange we guarantee that the same skill is never hooked twice as the MaxRange is increased during the hooking
				if (activeSkill.getID() == "actives.knock_back")
				{
					// use locally defined function
					hookKnockBack(activeSkill);
				}
			}
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		local item = _skill.getItem();
		return !::MSU.isNull(item) && item.isItemType(::Const.Items.ItemType.Shield);
	}

	// Look at one of the remaining allies and try to trigger _skillID for free for them.
	// Then call itself recursively with one less remainingAlly
	q.triggerCopycat <- function( _data )
	{
		if (_data.RemainingAllies.len() == 0) return;

		local ally = ::MSU.Array.rand(_data.RemainingAllies);
		::MSU.Array.removeByValue(_data.RemainingAllies, ally);
#
		local triggeredSkill = false;

		if (!ally.getCurrentProperties().IsStunned && ally.m.MoraleState != ::Const.MoraleState.Fleeing)
		{
			foreach (activeSkill in ally.getSkills().getAllSkillsOfType(::Const.SkillType.Active))
			{
				if (activeSkill.getID() == _data.SkillID)
				{
					activeSkill.m.HD_Temp_IsFree = true;
					if (activeSkill.isUsable())
					{
						local allyTile = ally.getTile();
						local validTargets = [];
						if (activeSkill.isUsableOn(allyTile))
						{
							validTargets.push(allyTile);	// Allows skills like shieldwall to be used
						}
						foreach (nextTile in ::MSU.Tile.getNeighbors(allyTile))
						{
							if (activeSkill.isUsableOn(nextTile))
							{
								validTargets.push(nextTile);
							}
						}
						if (validTargets.len() != 0)
						{
							local chosenTile = ::MSU.Array.rand(validTargets);
							activeSkill.use(chosenTile, true);
						}
						activeSkill.m.HD_Temp_IsFree = false;
						triggeredSkill = true;
						break;	// We ignore multiple active skills using the same ID
					}
					activeSkill.m.HD_Temp_IsFree = false;
				}
			}
		}

		if (triggeredSkill)
		{
			::Time.scheduleEvent(::TimeUnit.Virtual, _data.Self.m.ExecutionDelay, _data.Self.triggerCopycat, _data);
		}
		else	// Nothing happened; No delay needed
		{
			_data.Self.triggerCopycat(_data);
		}
	}
});
