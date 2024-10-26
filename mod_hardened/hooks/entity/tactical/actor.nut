::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Public
	q.m.StaminaMin <- 10;	// This actor can never have less than this amount of Stamina

	// Private
	q.m.GrantsXPOnDeath <- true;

	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/special/hd_direct_damage_limiter"));
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

	q.hasZoneOfControl = @(__original) function()
	{
		return __original() && this.getCurrentProperties().CanExertZoneOfControl;
	}

	// For Vanilla you'd hook onActorKilled on player.nut. But Reforged moved the exp calculation over into the onDeath of actor.nut
	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		local lootTile = _tile;
		if (lootTile == null && this.isPlacedOnMap()) lootTile = this.getTile();
		if (lootTile != null)
		{
			foreach (item in this.getDroppedLoot(_killer, _skill, _fatalityType))
			{
				item.drop(lootTile);
			}
		}

		local oldGlobalXPMult = ::Const.Combat.GlobalXPMult;
		if (this.isAlliedWithPlayer() || !this.m.GrantsXPOnDeath)
		{
			::Const.Combat.GlobalXPMult = 0;	// The player no longer gains any experience when allies are dying
		}

		__original(_killer, _skill, _tile, _fatalityType);

		::Const.Combat.GlobalXPMult = oldGlobalXPMult;
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

// New Functions
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

// New Events
	// This is called just before onDeath of this entity is called
	q.getDroppedLoot <- function( _killer, _skill, _fatalityType )
	{
		return [];
	}
});
