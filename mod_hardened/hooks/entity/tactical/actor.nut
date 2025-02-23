::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Public
	q.m.StaminaMin <- 10;	// This actor can never have less than this amount of Stamina

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

		// We allow nachzehrer to consider swalling even if that is the last enemy they know of by tricking vanilla in always thinking there are 2 known enemies in this situation
		local mockObject = ::Hardened.mockFunction(::Tactical.State, "isAutoRetreat", function() {
			if (::Hardened.getFunctionCaller(1) == "kill")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
			{
				return { value = true };		// The only important thing here is that the returned array has more than 1 element
			}
		});

		__original(_killer, _skill, _fatalityType, _silent);
		mockObject.cleanup();	// We clean up our mock function now

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

// New Getter
	// Return the Stamina of this character utilizing the new Hardened formula
	// @return Stamina (Maximum Fatigue) of this character
	q.getStamina <- function()
	{
		local stamina = this.getCurrentProperties().getStamina();
		stamina += this.getStaminaModifierFromWeight();	// Stamina modifiers from weight are now applied AFTER the StaminaMult from effects (injuries, perks) is applied
		return ::Math.max(stamina, this.m.StaminaMin);	// New: We now introduce a minimum Stamina value. At worst a character should still be able to throw a fist or move one tile
	}

	// Calculate the total Stamina Modifier from the Weight of all equipped gear
	q.getStaminaModifierFromWeight <- function()
	{
		local staminaModifier = 0;
		foreach (index, _ in ::Const.ItemSlotSpaces) // index corresponds to a valid slot in ::Const.ItemSlot
		{
			local mult = this.m.CurrentProperties.WeightStaminaMult[index];
			foreach (item in this.getItems().getAllItemsAtSlot(index))
			{
				staminaModifier -= item.getWeight() * mult;
			}
		}
		return ::Math.round(staminaModifier);
	}

	// Calculate the total Initiative Modifier from the Weight of all equipped gear
	q.getInitiativeModifierFromWeight <- function()
	{
		local initiativeModifier = 0;
		foreach (itemSlot, _ in ::Const.ItemSlotSpaces)
		{
			local mult = this.m.CurrentProperties.WeightInitiativeMult[itemSlot];
			foreach (item in this.getItems().getAllItemsAtSlot(itemSlot))
			{
				initiativeModifier -= item.getWeight() * mult;
			}
		}
		return ::Math.round(initiativeModifier);
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
	// This must happen as hookTree because we need to wrap around all implementations of it by its childs
	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		// Our Goal:
		// - If this actor is player controlled or if the player did 50% or more damage to them, allocate their loot to the player (as if you last hitted someone in Vanilla)
		// - Otherwise don't allocate the loot to the player (as if in Vanilla someone stole your kill)
		// The Idea:
		// - Spawn Loot:
		// 		- We need to pass the common checks standardized by Vanilla in onDeath and dropAll, so that items are dropped.
		//		- But we need to be as compatible as possible (we can't just set the _killer in onDeath to null, as that causes issues with e.g. Fun Facts)
		// - Don't spawn Loot:
		//		- We need to prevent any item from being generated and dropped. The exception are Legendary items (Ijirok Armor, Lightning Sword)

		// First we determine, whether this dying actor spawns loot for the player
		local spawnLoot = false;
		if (this.isPlayerControlled())
		{
			spawnLoot =  true;
		}
		else
		{
			local playerRelevantDamage = 0.0;
			if (::Const.Faction.Player in this.m.RF_DamageReceived)
				playerRelevantDamage += this.m.RF_DamageReceived[::Const.Faction.Player].Total;
			if (::Const.Faction.PlayerAnimals in this.m.RF_DamageReceived)
				playerRelevantDamage +=  this.m.RF_DamageReceived[::Const.Faction.PlayerAnimals].Total;

			// If player + player animals did at least 50% of total damage to this actor, we set the _killer to null to ensure that the loot properly drops from this actor.
			// This is because vanilla drops loot if _killer is null or belongs to Player or PlayerAnimals faction.
			// Warning: This will break any mod that hooks the original onDeath and expects _killer to represent the actual killer
			if (playerRelevantDamage / this.m.RF_DamageReceived.Total >= 0.5)
			{
				spawnLoot = true;
			}
		}

		if (spawnLoot)
		{
			if (_killer == null)	// This is the easy case. A _killer of null will always spawn loot for the player (unless for allies of the player, but that's to be expected)
			{
				return __original(_killer, _skill, _tile, _fatalityType);
			}
			else
			{
				// Part one: Make Non-Equipped gear drop, by pretending that the killer was of the faction PlayerAnimal
				local mockObjectGetFaction = ::Hardened.mockFunction(_killer, "getFaction", function() {
					if (::Hardened.getFunctionCaller(1) == "onDeath")	// This stops working if any mod ever overwrites the onDeath function of an actor
					{
						return { value = ::Const.Faction.PlayerAnimals };		// The only important thing here is that the returned array has more than 1 element
					}
				});

				// Part two:
				local mockObjectDropAll;
				mockObjectDropAll = ::Hardened.mockFunction(this.getItems(), "dropAll", function(_tile, _killer, _flip = false) {
					if (::Hardened.getFunctionCaller(1) == "onDeath")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
					{
						// We call dropAll with null to trick Vanilla into dropping loot from it in a normal way
						mockObjectDropAll.original(_tile, null, _flip);
						return { value = null };		// We return null explicitely to prevent the original function from being called
					}
				});

				__original(_killer, _skill, _tile, _fatalityType);

				mockObjectGetFaction.cleanup();	// It is possible that our mock function was never called, so we must clean up now
				mockObjectDropAll.cleanup();	// It is likely that our mock function was never called, so we must clean up now
			}
		}
		else
		{
			// Part one: Make isPlayerControlled return false and isAlliedWithPlayer return true, so that equipped items are marked as "IsDroppingLoot == false"
			local mockObjectIsPlayerControlled = ::Hardened.mockFunction(this, "isPlayerControlled", function() {
				if (::Hardened.getFunctionCaller(1) == "dropAll")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
				{
					return { value = false };
				}
			});

			local mockObjectIsAlliedWithPlayer = ::Hardened.mockFunction(this, "isAlliedWithPlayer", function() {
				if (::Hardened.getFunctionCaller(1) == "dropAll")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
				{
					return { value = true };
				}
			});

			// Part two: hook the ::new function to stop dropping anything, which is not a legendary item, when called by the onDeath function
			local mockObjectNew;
			mockObjectNew = ::Hardened.mockFunction(::getroottable(), "new", function( _scriptName ) {
				if (::Hardened.getFunctionCaller(1) == "onDeath")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
				{
					local ret = mockObjectNew.original(_scriptName);

					if (!ret.isItemType(::Const.Items.ItemType.Legendary))	// Legendary items by vanilla definition always drop, no matter what
					{
						item.drop <- @(...)null;
					}

					return { value = itemsToChange };
				}
			});

			__original(_killer, _skill, _tile, _fatalityType);

			mockObjectIsPlayerControlled.cleanup();
			mockObjectIsAlliedWithPlayer.cleanup();
			mockObjectNew.cleanup();
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
