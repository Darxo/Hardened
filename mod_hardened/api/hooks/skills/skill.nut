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
	q.m.StunChance <- 0;	// We add this to all skills, so it's easier to read it out, especially for AI scripts
	q.m.HD_Cooldown <- 0;	// This skill can only be used if HD_RoundLastUsed is null or at least this many rounds ago
	q.m.IsHidingIconMini <- false;	// If set to true, then the IconMini will be treated as if it was an empty string and never display
	q.m.HD_IgnoreForCrowded <- false;	// When true, then this skill will not be affected by crowded, even if it passes all other conditions for that
	q.m.HD_IsSortedBeforeMainhand <- false;	// If true, then this active is sorted even before mainhand actives in the UI. Useful for skills like hand-to-hand or bite
	q.m.HD_LastsForTurns <- null;	// When not null, this will decrement at the end of each turn and remove this skill, when it reaches 0
	q.m.HD_LastsForRounds <- null;	// When not null, this will decrement at the end of each round and remove this skill, when it reaches 0
	q.m.HD_KnockBackDistance <- 1;	// [SoftReset] Might be used by certain active skills to determine, how far they knock back a target

	// Private
	q.m.HD_RoundLastUsed <- null;	// This is set to the current round whenever the skills onUse is called
	q.m.HD_Temp_IsFree <- false;	// Ignore fatigue and action point cost during isAffordable check
	q.m.HD_ForFree <- false;		// Is always set to the _forFree value of the last skill::use call of this skill. We use it to access this value in our onUse hook

	q.isAffordable = @(__original) function()
	{
		if (this.m.HD_Temp_IsFree) return true;	// Allows us to do a vanilla isUsableOn check without considering the cost. Useful for triggering other characters skills
		return __original();
	}

	q.use = @(__original) function( _targetTile, _forFree = false )
	{
		::Hardened.Temp.LastUsedSkill = ::MSU.asWeakTableRef(this);		// We can expect the skill to exist long enough, even if it is removed from the actor, usually within delayed events
		::Hardened.Temp.LastUsedSkillOwner = ::MSU.asWeakTableRef(this.getContainer().getActor());	// The skill might not have an owner anymore by that time, e.g. with Throwing Spear skill
		this.m.HD_ForFree = _forFree;

		return __original(_targetTile, _forFree);
	}

	q.onScheduledTargetHit = @(__original) function( _info )
	{
		if (!_info.TargetEntity.isAlive())
		{
			return __original(_info);
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

// MSU Functions
	q.softReset = @(__original) function()
	{
		__original();
		this.resetField("IsUsable");
		this.resetField("HD_KnockBackDistance");
	}

// Modular Vanilla Events
	q.MV_onAttackEntityMissed = @(__original) function( _attackInfo )
	{
		::Hardened.Temp.LastAttackInfo = ::MSU.asWeakTableRef(_attackInfo);
		__original(_attackInfo);
	}

// New Functions
	// New virtual function that is already used various times in different vanilla skills
	q.findTileToKnockBackTo <- function( _userTile, _targetTile )
	{
		return null;
	}

	// Returns this.getTooltip but strips away all children member from all tooltip entries
	// Should be used, when fetching a tooltip that is to be displayed as children already, as nested children break tooltips break the tooltip box
	q.getTooltipWithoutChildren <- function()
	{
		local ret = this.getTooltip();

		foreach (entry in ret)
		{
			if (!("children" in entry)) continue;
			delete entry["children"];
		}

		return ret;
	}

// New Getter
	q.isOnCooldown <- function()
	{
		if (this.m.HD_RoundLastUsed == null) return false;

		return ::Time.getRound() < this.m.HD_RoundLastUsed + this.m.HD_Cooldown;
	}

	// Return the expected shield damage multiplier incluencing this skill, when targeting the shield of _target
	q.getExpectedShieldDamageMult <- function( _target = null )
	{
		local actor = this.getContainer().getActor();
		local propAttacker = this.getContainer().buildPropertiesForUse(this, _target);
		local ret = propAttacker.ShieldDamageMult;
		if (_target != null)
		{
			local propDefender = _target.getSkills().buildPropertiesForDefense(actor, this);
			ret *= propDefender.ShieldDamageReceivedMult;
		}
		return ret;
	}

	/// Toggle the IsUsable flag of all skills on this character, which pass an check. If at least one skill has changed, update the entities UI
	/// During an onUpdateProperties you should only ever call this with 'false' as otherwise multiple effect will conflict with each other
	/// It is important that you call this with 'true' when combat ends or your effect is removed to prevent the character bring temporarily bricked
	/// @param _enabled new value for the this.m.IsUsable flag
	/// @param _condition function that takes a _skill as an argument and returns either true or false
	q.setSkillsIsUsable <- function( _enabled, _condition )
	{
		local changeHappened = false;
		foreach (skill in this.getContainer().m.Skills)
		{
			if (_condition(skill))
			{
				if (skill.m.IsUsable != _enabled)
				{
					changeHappened = true;
					skill.m.IsUsable = _enabled;
				}
			}
		}

		if (changeHappened)	// Otherwise during the onUpdate loop we would constantly update the UI
		{
			this.getContainer().getActor().setDirty(true);	// Update the UI so that enable/disable status is visible instantly
		}
	}

// New Events
	/// _skill is the new skill that was just added to this skills skill_container
	q.onOtherSkillAdded <- function( _skill )
	{
	}

	// This event is only called directly before a skills onUse was executed
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
	}

	// This event is only called directly after a skills onUse was executed
	/// _success is the return value of the vanilla onUse function
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
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.isOnCooldown())
		{
			local remainingCooldown = this.m.HD_RoundLastUsed + this.m.HD_Cooldown - ::Time.getRound();
			ret.push({
				id = 42,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Can be used again in " + ::MSU.Text.colorNegative(remainingCooldown) + ::Reforged.Mod.Tooltips.parseString(" [round(s)|Concept.Round]"),
			});
		}
		else
		{
			if (this.m.HD_Cooldown == 1)
			{
				ret.push({
					id = 42,
					type = "text",
					icon = "ui/icons/action_points.png",
					text = ::Reforged.Mod.Tooltips.parseString("Can only be used once per [round(s)|Concept.Round]"),
				});
			}
			else if (this.m.HD_Cooldown > 1)
			{
				ret.push({
					id = 42,
					type = "text",
					icon = "ui/icons/action_points.png",
					text = "Can only be used once every " + ::MSU.Text.colorNegative(this.m.HD_Cooldown) + ::Reforged.Mod.Tooltips.parseString(" [rounds|Concept.Round]"),
				});
			}
		}

		if (this.m.HD_LastsForTurns == 1)
		{
			local entry = {
				id = 42,	// we use the same ID as cooldown as both tooltips should never appear on the same skill
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Lasts until the end of ",
			};
			entry.text += this.getContainer().getActor().isActiveEntity() ? "this": "your next";
			entry.text += ::Reforged.Mod.Tooltips.parseString(" [turn|Concept.Turn]");
			ret.push(entry);
		}
		else if (this.m.HD_LastsForTurns > 1)
		{
			ret.push({
				id = 42,	// we use the same ID as cooldown as both tooltips should never appear on the same skill
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Lasts for " + ::MSU.Text.colorPositive(this.m.HD_LastsForTurns) + ::Reforged.Mod.Tooltips.parseString(" [turns|Concept.Turn]"),
			});
		}

		if (this.m.HD_LastsForRounds == 1)
		{
			ret.push({
				id = 42,	// we use the same ID as cooldown as both tooltips should never appear on the same skill
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Lasts until the end of this " + ::Reforged.Mod.Tooltips.parseString("[round|Concept.Round]"),
			});
		}
		else if (this.m.HD_LastsForRounds > 1)
		{
			ret.push({
				id = 42,	// we use the same ID as cooldown as both tooltips should never appear on the same skill
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Lasts for " + ::MSU.Text.colorPositive(this.m.HD_LastsForRounds) + ::Reforged.Mod.Tooltips.parseString(" [rounds|Concept.Round]"),
			});
		}

		return ret;
	}

	// Vanilla does not guarantee, that this skill is 0 or greater, so we enforce this here.
	// Negative values can happen, when multiple skills offer a flat AP discount, or when designing skills with a negative base action point cost (passing step)
	q.getActionPointCost = @(__original) function()
	{
		return ::Math.max(0, __original());
	}

	q.isUsable = @(__original) function()
	{
		return !this.isOnCooldown() && __original();
	}

	q.onAdded = @(__original) function()
	{
		__original();
		this.getContainer().onOtherSkillAdded(this);
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.HD_RoundLastUsed = null;
	}

	q.onRoundEnd = @(__original) function()
	{
		__original();
		if (this.m.HD_LastsForRounds != null)
		{
			--this.m.HD_LastsForRounds;
			if (this.m.HD_LastsForRounds == 0) this.removeSelf();
		}
	}

	q.onTurnEnd = @(__original) function()
	{
		__original();
		if (this.m.HD_LastsForTurns != null)
		{
			--this.m.HD_LastsForTurns;
			if (this.m.HD_LastsForTurns == 0) this.removeSelf();
		}
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		// Todo, only do that during your turn? What happens if this is triggered during someone elses turn?
		this.m.HD_RoundLastUsed = ::Time.getRound();	// Imprint the last round in which this skill was used for the cooldown framework

		// Fix(Vanilla): some perk implementations (Headhunter, Fast Adaption, Full Force) triggering/not-triggering from zone-of-control attacks
		// Those attacks count as _forFree but also as full skill uses (rather than just attacks).
		// They do not advance the SkillCounter in Vanilla, so such perks think they are still part of the previous skill execution and ignore/count them
		// We fix that by making any free skill now advance the skill counter, if it is the very first skill use of a skill-chain
		if (::Hardened.Temp.RootSkillCounter == null && this.m.HD_ForFree) ++::Const.SkillCounter;

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


