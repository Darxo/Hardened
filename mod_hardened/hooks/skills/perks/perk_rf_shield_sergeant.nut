// hook a skill that can
local hookKnockBack = function( _o )
{
	if ("HD_IsShieldSergeantHooked" in _o.m) return;	// This skill is already hooked
	_o.m.HD_IsShieldSergeantHooked <- true;

	local oldOnVerifyTarget = _o.onVerifyTarget;
	_o.onVerifyTarget = function( _user, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
		{
			return true;	// Even tiles blocked by obstacles or 2 levels higher are allowed. However vanilla does not highlight them correctly. This is an easter egg
		}

		return oldOnVerifyTarget(_user, _targetTile);
	}

	local oldOnuse = _o.onUse;
	_o.onUse = function( _user, _targetTile )
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
	q.m.FreeUseTileDistance <- 3;

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

		// In order to prevent loops, we secretly prevent a free use from triggering
		local item = _skill.getItem();
		if (!_forFree && !::MSU.isNull(item) && item.isItemType(::Const.Items.ItemType.Shield))
		{
			local potentialAllies = [];
			local actor = this.getContainer().getActor();
			foreach (ally in ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), this.m.FreeUseTileDistance))
			{
				if (ally.getID() == actor.getID()) continue;
				potentialAllies.push(ally);
			}
			::MSU.Array.shuffle(potentialAllies);

			::Time.scheduleEvent(::TimeUnit.Virtual, 150, this.triggerCopycat, {
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
	// Look at one of the remaining allies and try to trigger _skillID for free for them.
	// Then call itself recursively with one less remainingAlly
	q.triggerCopycat <- function( _data )
	{
		if (_data.RemainingAllies.len() == 0) return;

		local delay = 150;
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
						for (local i = 0; i <= 5; ++i)
						{
							if (!allyTile.hasNextTile(i)) continue;

							local nextTile = allyTile.getNextTile(i);
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
			::Time.scheduleEvent(::TimeUnit.Virtual, delay, _data.Self.triggerCopycat, _data);
		}
		else	// Nothing happened; No delay needed
		{
			_data.Self.triggerCopycat(_data);
		}
	}
});
