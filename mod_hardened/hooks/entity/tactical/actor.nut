::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/special/hd_direct_damage_limiter"));
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
	q.getInitiative = @() function()
	{
		local initiative = this.m.CurrentProperties.getInitiative();
		initiative -= this.getFatigue() * this.m.CurrentProperties.FatigueToInitiativeRate;		// Subtract Accumulated Fatigue from Initiative
		initiative += this.getInitiativeModifierFromWeight();
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

	// Overwrite, because we don't like the vanilla way of determining loot
	q.isLootAssignedToPlayer = @() function( _killer )
	{
		// Player controlled characters always drop loot, no matter who kills them
		if (this.isPlayerControlled()) return true;

		// Allies never drop loot for the player, even if the player did most of the damage to them
		if (this.isAlliedWithPlayer()) return false;

		local playerRelevantDamage = 0.0;
		if (::Const.Faction.Player in this.m.RF_DamageReceived)
			playerRelevantDamage += this.m.RF_DamageReceived[::Const.Faction.Player].Total;
		if (::Const.Faction.PlayerAnimals in this.m.RF_DamageReceived)
			playerRelevantDamage +=  this.m.RF_DamageReceived[::Const.Faction.PlayerAnimals].Total;

		// If player + player animals did at least 50% of total damage to this actor, they gain the loot , we set the _killer to null to ensure that the loot properly drops from this actor.
		// This is because vanilla drops loot if _killer is null or belongs to Player or PlayerAnimals faction.
		return (playerRelevantDamage / this.m.RF_DamageReceived.Total >= 0.5)
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
	q.getLootForTile = @(__original) function( _killer, _loot )
	{
		// Our Goal:
		// - If the isLootAssignedToPlayer function deems this loot to be player-loot we adjust the _killer argument in a way to
		// 		either fully pass or never pass the generic vanilla condition for dropping loot
		if (this.isLootAssignedToPlayer(_killer))
		{
			return __original(null, _loot);	// We pass null, because that will always pass the generic vanilla conditions for dropping loot
		}
		else
		{
			local dummyNonPlayer = ::MSU.getDummyPlayer();
			local dummyPlayerFaction = dummyNonPlayer.getFaction();
			dummyNonPlayer.setFaction(::Const.Faction.None);	// We set the faction to none, so we fail all generic vanilla conditions for dropping loot

			// Some loot will still be dropped, but that is then usually by design of that specific enemy/mod
			local ret = __original(dummyNonPlayer, _loot);

			dummyNonPlayer.setFaction(dummyPlayerFaction);	// Revert the dummy faction, because other mods might expect it to be of player faction

			return ret;
		}
	}

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
