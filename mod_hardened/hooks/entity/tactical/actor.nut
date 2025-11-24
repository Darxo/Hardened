::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Public
	q.m.HD_FleeingMoraleChecksPerTurn <- 1;	// This actor will becomes immune to morale checks from fleeing after receiving this many morale checks from that

	// Private
	q.m.HD_FleeingMoraleChecksLeft <- 0;
	q.m.HD_FleeingMoraleTurnNumber <- -1;	// Set to the last turn number, that we had morale checks in, to keep track of when to reset the fleeing morale checks
	q.m.HD_IsDiscovered <- false;	// Is true, when setDiscovered(true) has been called on us. Is set to false at the start of every round or when this actor steps into a tile not visible to the player

	q.checkMorale = @(__original) { function checkMorale( _change, _difficulty, _type = ::Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		local oldMoraleState = this.m.MoraleState;
		local ret = __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);

		if (oldMoraleState == ::Const.MoraleState.Fleeing && this.m.MoraleState == ::Const.MoraleState.Wavering)	// This is our current definition of being rallied
		{
			// Feat: Any character that rallies, loses some action points
			this.setActionPoints(this.getActionPoints() + ::Hardened.Const.ActionPointChangeOnRally);
		}

		return ret;
	}}.checkMorale;

	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/special/hd_direct_damage_limiter"));

		// This is one of the few function given to entities somewhere after create() but before onInit()
		local oldSetDiscovered = this.setDiscovered;
		this.setDiscovered = function( _b )
		{
			if (_b) this.HD_onDiscovered();
			oldSetDiscovered(_b);
		}

		// This is one of the few function given to entities somewhere after create() but before onInit()
		local oldSetRenderCallbackEnabled = this.setRenderCallbackEnabled;
		this.setRenderCallbackEnabled = function( _bool )
		{
			// Vanilla Fix: We prevent Vanilla from disabling the RenderCallBack after raising the shield if it is still supposed to lower it afterwards
			// This is related to the Vanilla Fix about Shieldwall Animation not being removed correctly; See onAppearanceChanged Vanilla Fix
			if (_bool == false && this.m.IsLoweringShield)
			{
				return oldSetRenderCallbackEnabled(true);
			}

			oldSetRenderCallbackEnabled(_bool);
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

	// Seems to be called from within the .exe and also doesnt seem related to setDiscovered
	q.onDiscovered = @(__original) function()
	{
		this.HD_onDiscovered();
		__original();
	}

	q.onFactionChanged = @(__original) function()
	{
		local flip = !this.isAlliedWithPlayer();
		__original();
		if (this.hasSprite("HD_frenzy_eyes")) this.getSprite("HD_frenzy_eyes").setHorizontalFlipping(flip);
	}

	q.kill = @(__original) function( _killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false )
	{
		local wasAlive = this.isAlive();	// We have to save that state here, because it flips during the execution of __original

		local oldRelationUnitKilled = ::Const.World.Assets.RelationUnitKilled;
		::Const.World.Assets.RelationUnitKilled = 0;
		__original(_killer, _skill, _fatalityType, _silent);
		::Const.World.Assets.RelationUnitKilled = oldRelationUnitKilled;

		if (!wasAlive) return;	// Same check as Vanilla
		if (::Tactical.State.isScenarioMode()) return;	// Many global objects dont exist here, like FactionManager

		// Some contracts force you to fight against their own (deserter twist), we dont want those cases to cause non-scripted relation damage
		local currentContract = ::World.Contracts.getActiveContract();
		if (currentContract != null && this.getFaction() == currentContract.getFaction()) return;

		// This code is mostly a copy of vanillas checks, except that we don't check for ::World.FactionManager.getFaction(this.getFaction()).isTemporaryEnemy()
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		if (faction != null && _killer != null && (_killer.getFaction() == ::Const.Faction.Player || _killer.getFaction() == ::Const.Faction.PlayerAnimals))
		{
			faction.addPlayerRelation(::Const.World.Assets.RelationUnitKilled, "Killed one of their units");
		}
	}

	q.killSilently = @(__original) function()
	{
		// Anyone who is killed silently, will also cause a Relationship hit for the player. That mainly relates to Donkeys
		local faction = ::World.FactionManager.getFaction(this.getFaction());
		if (faction != null)
		{
			// Some contracts force you to fight against their own (deserter twist), we dont want those cases to cause non-scripted relation damage
			local currentContract = ::World.Contracts.getActiveContract();
			if (currentContract == null || this.getFaction() != currentContract.getFaction())
			{
				faction.addPlayerRelation(::Const.World.Assets.RelationUnitKilled, "Killed one of their units");
			}
		}

		__original();
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

		__original(_type, _volume, _pitch);
	}

	q.onAppearanceChanged = @(__original) function( _appearance, _setDirty = true )
	{
		__original(_appearance, _setDirty);
		if (!this.m.IsAlive || this.m.IsDying) return;	// Same early return as in Vanilla

		// Vanilla Fix: In Vanilla a shield can not be visually lowered, if it has not been visually raised yet (offset.Y != 0)
		// A shield can only be visually raised/lowered, while an entity is rendering (= visible to the player)
		// So if an NPC gets shieldwall but is not visible; and then a little later loses shieldwall, it will not get this.m.IsLoweringShield set to true;
		// Its shield will appear raised up until any other onAppearanceChanged call happens on them
		// We fix that bug here by also allowing this.m.IsLoweringShield to be set to true, when this.m.IsRaisingShield == true
		if (this.hasSprite("shield_icon") && _appearance.Shield.len() != 0)
		{
			local offset = this.getSpriteOffset("shield_icon");
			if (!this.m.IsLoweringShield && !_appearance.RaiseShield && (offset.Y != 0 || this.m.IsRaisingShield))	// This is the only different line to vanilla logic
			{
				this.m.IsLoweringShield = true;
				this.setRenderCallbackEnabled(true);
				this.m.RenderAnimationStartTime = ::Time.getVirtualTimeF();
			}
		}
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
	// Feat: Fleeing allies dont trigger morale checks on us, if we can't see them
	// 		or if we already had HD_FleeingMoraleChecksPerTurn morale checks triggered on us, this turn
	q.onOtherActorFleeing = @(__original) function( _actor )
	{
		if (!this.m.IsAlive || this.m.IsDying) return;

		if (this.m.HD_FleeingMoraleTurnNumber != ::Tactical.TurnSequenceBar.getTurnPosition())
		{
			this.m.HD_FleeingMoraleTurnNumber = ::Tactical.TurnSequenceBar.getTurnPosition();
			this.m.HD_FleeingMoraleChecksLeft = this.m.HD_FleeingMoraleChecksPerTurn;
		}

		// Either we already had enough fleeing morale checks, or we can't see the _actor who's fleeing
		// In Both situations, we become temporarily unaffected by fleeing allies
		local curProp = this.getCurrentProperties();
		if (this.m.HD_FleeingMoraleChecksLeft == 0 || this.getTile().getDistanceTo(_actor.getTile()) > curProp.getVision())
		{
			local oldIsAffectedByFleeingAllies = curProp.IsAffectedByFleeingAllies;
			curProp.IsAffectedByFleeingAllies = false;
			__original(_actor);
			curProp.IsAffectedByFleeingAllies = oldIsAffectedByFleeingAllies;
			return;
		}

		local fleeMoraleCheckHappened = false;
		local mockObject = ::Hardened.mockFunction(this, "checkMorale", function( _change, _difficulty, _type = ::Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false ) {
			if (_change == -1)
			{
				fleeMoraleCheckHappened = true;
				return { done = true };
			}
		});

		__original(_actor);

		mockObject.cleanup();
		if (fleeMoraleCheckHappened)
		{
			--this.m.HD_FleeingMoraleChecksLeft;
		}
	}

	q.onRoundStart = @(__original) function()
	{
		__original();
		this.m.HD_IsDiscovered = this.getTile().IsVisibleForPlayer;
		this.m.HD_FleeingMoraleTurnNumber = -1;
	}

	q.onTurnResumed = @(__original) function()
	{
		this.logDebug("Turn resumed for " + this.getName());	// Vanilla only prints this log for when the turn starts. But resuming a turn is just as interesting of a state
		__original();
	}

// Hardened Functions
	// Our own interpretation of surroundedCount, that is not yet clamped
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

	// This is called either when onDiscovered or when setDiscovered(true) on this actor are called
	q.HD_onDiscovered <- function()
	{
		// Feat: stop player movement midway, when he discovers an enemy/ally
		// This is related to the setDiscovered hook in this script and the onMovementStep hook in the player.nut
		if (!this.m.HD_IsDiscovered && !this.isPlayerControlled() && ::Tactical.isActive())	// We must check for tactical to be active, because vanilla also calls setDiscovered(true) during initialization of a player object
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
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
	// If any character ever gets the sprite "dirt" added, we treat that as if they can handle glowy eyes
	// So we add our new glowy eyes sprite to them and the effect, which controls glowy eyes
	q.onInit = @(__original) function()
	{
		local mockObject;
		mockObject = ::Hardened.mockFunction(this, "addSprite", function( _spriteName ) {
			if (_spriteName == "dirt")
			{
				local ret = { done = true, value = mockObject.original(_spriteName) };

				local frenzyEyes = mockObject.original("HD_frenzy_eyes");		// We add the new sprite HD_frenzy_eyes directly after "dirt"
				frenzyEyes.setBrush("zombie_rage_eyes");
				frenzyEyes.Alpha = 200;
				this.getSkills().add(::new("scripts/skills/special/hd_frenzy_eyes_manager"));	// We add the new frenzy eyes manager special skill, that spawns the effect
				return ret;
			}
			return { done = false };
		});
		__original();
		mockObject.cleanup();
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

		// Every defender of a location gets a defenders advantage buff, if that location was fortified
		local party = this.getParty();
		if (party != null && party.isLocation() && party.getCombatLocation().Fortification != ::Const.Tactical.FortificationType.None)
		{
			this.getSkills().add(::new("scripts/skills/effects/hd_defenders_advantage"));
		}

		this.getSkills().onSpawned();
	}
});
