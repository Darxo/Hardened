::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Private
	q.m.HD_IsDiscovered <- false;	// Is true, when setDiscovered(true) has been called on us. Is set to false at the start of every round or when this actor steps into a tile not visible to the player

	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/special/hd_direct_damage_limiter"));

		// This is one of the few function given to entities somewhere after create() but before onInit()
		local oldSetDiscovered = this.setDiscovered;
		this.setDiscovered = function( _b )
		{
			if (_b && !this.m.HD_IsDiscovered && ::Tactical.isActive())		// We must check for tactical to be active, because vanilla also calls setDiscovered(true) during initialization of a player object
			{
				this.m.HD_IsDiscovered = true;	// We use this variable, so that we don't trigger the following behavior repeatidly on already discovered entities
				local activeEntity = ::Tactical.TurnSequenceBar.getActiveEntity();
				if (::MSU.isKindOf(activeEntity, "player"))
				{
					if (this.isAlliedWithPlayer() && ::Hardened.Mod.ModSettings.getSetting("HoldOnDiscoverAlly").getValue())
						activeEntity.m.HD_HasDiscoveredSomething = true;
					if (!this.isAlliedWithPlayer() && ::Hardened.Mod.ModSettings.getSetting("HoldOnDiscoverHostile").getValue())
						activeEntity.m.HD_HasDiscoveredSomething = true;
				}
			}

			oldSetDiscovered(_b);
		}
	}

	// Vanilla Fix: We prevent a dying NPC from flipping the setLastCombatResult, unless they were the last enemy to die
	// This prevents a bug in the Sunken Library, where the player wins if his last brother dies from a Flying Skull detonation
	// The issue in Vanilla is that the Skull dies first, within its Kill function the player dies
	// but the last thing happening is the skull registering its death for setLastCombatResult, making this a player win
	q.kill = @(__original) function( _killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false )
	{
		if (this.isPlayerControlled())	// We are only interested in non-player deaths
		{
			return __original(_killer, _skill, _fatalityType, _silent);
		}

		// We make sure that isAutoRetreat always returns true, so that the lastCombatResult is not set to EnemyDestroyed by vanilla during the kill function
		local mockObject = ::Hardened.mockFunction(::Tactical.State, "isAutoRetreat", function() {
			return { value = true };
		});

		__original(_killer, _skill, _fatalityType, _silent);

		mockObject.cleanup();

		// If a kill happens within a kill (e.g. Flying Skull kills another Flying Skull), then multiple Mocks happen
		//  and only the root kill caller, gets an honest read on "isAutoRetreat". Only he is able to actually setLastCombatResult correctly
		if (!::Tactical.State.isAutoRetreat())
		{
			if (::Tactical.Entities.getHostilesNum() == 0)	// If not all enemies have died yet, we don't want to draw conclusions too early so we revert back to the previous state
			{
				::Tactical.Entities.setLastCombatResult(::Const.Tactical.CombatResult.EnemyDestroyed);
			}
		}
	}

	q.wait = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/effects/hd_wait_effect"));
	}

	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		local oldHitpoints = this.getHitpoints();
		local mockObject = ::Hardened.mockFunction(this, "kill", function(_killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false) {
			// Vanilla Fix: Vanilla never prints a hitpoint damage combat log, when the attack kills the target, so we do that here now
			::Tactical.EventLog.logEx(format("%s\'s %s (%i) is hit for %i damage", ::Const.UI.getColorizedEntityName(this), ::Const.Strings.BodyPartName[_hitInfo.BodyPart], oldHitpoints, ::Math.floor(_hitInfo.DamageInflictedHitpoints)));
			return { done = true };
		});

		__original(_attacker, _skill, _hitInfo);

		mockObject.cleanup();
	}

	q.playIdleSound = @(__original) function()
	{
		// Characters who are off-screen no longer produce idle sounds. However they will still be randomly selected as targets for making the idle sound.
		if (this.isPlacedOnMap() && this.getTile().IsVisibleForPlayer)
		{
			__original();
		}
	}

	q.playSound = @(__original) function( _type, _volume, _pitch = 1.0 )
	{
		// An actor that dies offscreen no longer produces a death sound
		if (_type == ::Const.Sound.ActorEvent.Death && !(this.isPlacedOnMap() && this.getTile().IsVisibleForPlayer))
		{
			return;
		}

		__original(_type, _volume, _pitch = 1.0);
	}

	q.onMovementFinish = @(__original) function( _tile )
	{
		__original(_tile);
		if (this.isPlayerControlled())
		{
			local camera = ::Tactical.getCamera();
			camera.Level = camera.getBestLevelForTile(_tile);	// Todo: Setting for this?
		}

		if (!_tile.IsVisibleForPlayer) this.m.HD_IsDiscovered = false;
	}

	q.onOtherActorDeath = @(__original) function( _killer, _victim, _skill )
	{
		if (!this.m.IsAlive || this.m.IsDying) return;

		// Morale Checks from allies fleeing are no longer triggered for you if you can't see them
		local curProp = this.getCurrentProperties();
		local distanceToVictim = this.getTile().getDistanceTo(_victim.getTile());
		local oldIsAffectedByDyingAllies = curProp.IsAffectedByDyingAllies;
		if (_victim.getFaction() == this.getFaction() && distanceToVictim > curProp.getVision())
		{
			curProp.IsAffectedByDyingAllies = false;
		}

		__original(_killer, _victim, _skill);

		curProp.IsAffectedByDyingAllies = oldIsAffectedByDyingAllies;
	}

	// This event is only fired for characters of the same faction as the one who started fleeing
	q.onOtherActorFleeing = @(__original) function( _actor )
	{
		if (!this.m.IsAlive || this.m.IsDying) return;

		// Morale Checks from allies fleeing are no longer triggered for you if you can't see them
		local curProp = this.getCurrentProperties();
		local oldIsAffectedByFleeingAllies = curProp.IsAffectedByFleeingAllies;

		local distanceToVictim = this.getTile().getDistanceTo(_actor.getTile());
		if (distanceToVictim > curProp.getVision())
		{
			curProp.IsAffectedByFleeingAllies = false;
		}

		__original(_actor);

		curProp.IsAffectedByFleeingAllies = oldIsAffectedByFleeingAllies;
	}

	q.onRoundStart = @(__original) function()
	{
		__original();
		this.m.HD_IsDiscovered = this.getTile().IsVisibleForPlayer;
	}

	q.onTurnResumed = @(__original) function()
	{
		this.logDebug("Turn resumed for " + this.getName());	// Vanilla only prints this log for when the turn starts. But resuming a turn is just as interesting of a state
		__original();
	}

	// Overwrite because we don't want the Vanilla way of calculating
	q.getFatigueMax = @() function()
	{
		return this.getStamina();
	}

	// Overwrite because we don't want the Vanilla way of calculating
	// Changes:
	// 	- Weight now affects your Initiative AFTER multipliers (instead of before)
	// 	- Effects, which lower your Stamina below your BaseStamina no longer lower your Initiative
	q.getInitiative = @() function()
	{
		local initiative = this.m.CurrentProperties.getInitiative();	// This includes base initiative, modifier and multiplier
		initiative -= this.getFatigue() * this.m.CurrentProperties.FatigueToInitiativeRate;		// Subtract Accumulated Fatigue from Initiative
		initiative += this.getInitiativeModifierFromWeight();	// Subtract Weight from Initiative
		return ::Math.round(initiative);
	}

// Hardened Functions
	q.__calculateSurroundedCount = @(__original) function()
	{
		local count = __original();

		if (!this.isPlacedOnMap()) return count;

		local myTile = this.getTile();
		foreach (enemy in ::Tactical.Entities.getHostileActors(this.getFaction(), myTile, 2))
		{
			if (!this.countsAsSurrounding(enemy)) continue;

			// Todo: consider making this logic more modular (e.g. move it to skill_container/skill function)
			local distance = myTile.getDistanceTo(enemy.getTile());
			if (distance == 1)
			{
				local perk = enemy.getSkills().getSkillByID("effects.rf_from_all_sides");
				if (perk != null)
				{
					count += perk.getSurroundedModifier(this);
				}
			}
			else if (distance == 2)
			{
				local perk = enemy.getSkills().getSkillByID("perk.rf_long_reach");
				if (perk != null)
				{
					count += perk.getSurroundedModifier(this);
				}
			}
		}

		return count;
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
// Reforged Events
	// This must happen as hookTree because there is no guarantee that someone overwriting it will call the child function
	q.onSpawned = @(__original) function()
	{
		__original();

		// The player no longer gains any experience when allies are dying
		if (!this.isPlayerControlled() && (this.m.XP == 0 || this.isAlliedWithPlayer()))
		{
			this.getSkills().add(::new("scripts/skills/effects/hd_unworthy_effect"));	// Every NPC who grants 0 XP now gains this effect to showcase that fact
		}

		if (this.m.IsNonCombatant)
		{
			this.getSkills().add(::new("scripts/skills/special/hd_non_combatant_effect"));	// Every NPC who is a non combatant now gains this effect to showcase that fact
		}

		this.getSkills().onSpawned();
	}
});
