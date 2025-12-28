::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Public
	q.m.GrantsXPOnDeath <- true;	// After initialisation this should ideally only ever be set in one direction (to false)
	q.m.StaminaMin <- 10;	// This actor can never have less than this amount of Stamina

	q.m.ChanceForNoChest <- 0;		// Value between 1 and 100 determining the chance for this actor to get no Body Armor assigned from ChestWeightedContainer
	q.m.ChestWeightedContainer <- null;		// If defined, the Body Armor worn by this actor will by assigned by this weighted container
	q.m.ChanceForNoHelmet <- 0;		// Value between 1 and 100 determining the chance for this actor to get no Helmet assigned from ChestWeightedContainer
	q.m.HelmetWeightedContainer <- null;	// If defined, the Helmet worn by this actor will by assigned by this weighted container
	q.m.ChanceForNoWeapon <- 0;		// Value between 1 and 100 determining the chance for this actor to get no Weapon assigned from WeaponWeightContainer
	q.m.WeaponWeightContainer <- null;		// If defined, the Weapon worn by this actor will by assigned by this weighted container
	q.m.ChanceForNoOffhand <- 0;		// Value between 1 and 100 determining the chance for this actor to get no Offhand assigned from OffhandWeightContainer
	q.m.OffhandWeightContainer <- null;		// If defined, the Offhand worn by this actor will by assigned by this weighted container

	// Private
	q.m.HD_recoveredHitpointsOverflow <- 0.0;	// float between 0.0 and 1.0. Is not deserialized, meaning that we lose a tiny bit hitpoint recovery when saving/loading often
	q.m.HD_ChanceToBeHit <- null;	// Contains an unsigned integer with the % chance that we will hit this entity when we are previewing a skill; null, if no hitchance should be displayed

	// Overwrite, because we re-implement the Reforged logic
	q.getSurroundedCount = @() function()
	{
		local tile = this.getTile();
		local count = -1;	// In Vanilla, the surrounded count always starts at -1, as in: we ignore the first adjacent enemy

		count += this.__calculateSurroundedCount();
		count -= this.getCurrentProperties().StartSurroundCountAt;

		return ::Math.max(0, count);
	}

	q.isTurnDone = @(__original) function()
	{
		if (this.getCurrentProperties().IsStunned) return true;		// Stun no longer sets the Action Points to 0 so we now need to adjust this function to always return true for stunned characters
		return __original();
	}

	q.onMovementFinish = @(__original) function ( _tile )
	{
		this.getSkills().update();	// This will allow skills to influence the vision of this entity, before updateVisibility with the destination tile is called
		__original(_tile);
		this.__possiblyChangedTileSituation();
	}

	q.hasZoneOfControl = @(__original) function()
	{
		return __original() && this.getCurrentProperties().CanExertZoneOfControl;
	}

	q.makeMiniboss = @(__original) function()
	{
		this.getSprite("miniboss").setBrush("bust_miniboss");	// Feat: we assign generic bust_miniboss here. That way we can save one line in every miniboss implementation
		return __original();
	}

	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/special/hd_bag_item_manager"));
	}

	q.onTurnEnd = @(__original) function()
	{
		__original();
		this.m.IsTurnStarted = true;
		// Vanilla sets this to false here, which is misleading and annyoing for modder and effect implementations
		// Someone who ended their turn still has had their turn started this round
		// Vanilla already resets this at the start of each round to false
	}

	q.setHitpoints = @(__original) function( _newHitpoints )
	{
		// We redirect any positive changes to the hitpoints to use recoverHitpoints and therefor be affected by the new 'HitpointRecoveryMult' property
		if (_newHitpoints > this.getHitpoints())
		{
			if (this.getHitpoints() < 0)
			{
				// Negative hitpoints will happen during a "Nine Lives" trigger; therefor we must first set the Hitpoints to 0, before we recover actual hitpoints
				__original(0);
			}
			local currentHitpoints = ::Math.max(0, this.getHitpoints());
			this.__recoverHitpointsSwitcheroo(_newHitpoints - currentHitpoints);
		}
		else
		{
			__original(_newHitpoints);
		}
	}

// New Getter
	// Return the Party instance, that this entity belongs to
	// @return world_party instance, if this entity belongs to one
	// @return null if this entity does not belong to a world party or that party became null for whatever reason
	q.getParty <- function()
	{
		if (::MSU.isNull(this.m.WorldTroop)) return null;
		if (!("Party" in this.m.WorldTroop)) return null;
		if (::MSU.isNull(this.m.WorldTroop.Party)) return null;;

		return this.m.WorldTroop.Party;
	}

	// Return the Stamina of this character utilizing the new Hardened formula
	// @return Stamina (Maximum Fatigue) of this character
	q.getStamina <- function()
	{
		local stamina = this.getCurrentProperties().getStamina();
		stamina += this.getStaminaModifierFromWeight();	// Stamina modifiers from weight are now applied AFTER the StaminaMult from effects (injuries, perks) is applied
		// New: We now introduce a minimum Stamina value. At worst a character should still be able to throw a fist or move one tile
		// We need to return a float value, because vanilla does not check against division by 0 in their getFatigueScoreMult function. The only way it doesnt crash is if the 0 is a float value
		return ::Math.maxf(stamina, this.m.StaminaMin);
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

	/// Utility function similar to the MSU function ::Tactical.TurnSequenceBar.isActiveEntity except that it first checks whether we are even in combat
	/// @return true if it is currently this entities turn
	/// @return false otherwise
	q.isActiveEntity <- function()
	{
		if (!::Tactical.isActive()) return false;

		// This is a similar implementation to what MSU does, except that we ignore IsLocked, by accessing the active entity directly
		// MSUs implementation has the issue, that it returns false during the start of the active entities turn,
		//	causing buffs, which rely on it being the active entity, to not apply immediately
		if (::Tactical.TurnSequenceBar.m.CurrentEntities.len() == 0) return false;

		return (this.getID() == ::Tactical.TurnSequenceBar.m.CurrentEntities[0].getID());
	}

	q.setPreviewSkillID = @(__original) function( _skillId )
	{
		__original(_skillId);

		// Feat: whenever the player previews a skill, we calculate the chance to hit every targetable entity with it
		// When the player stops previewing, we reset the calculated hitchances from all entities
		this.HD_toggleHitchanceOverlay(_skillId);
	}

// New functions
	/*
	Try to recover up to _amount Action Points
	@param _printLog if true, print a combat log entry stating how many Action Points were recovered
	@param _canExceedMaximum if true, then the maximum Action Points can be exceeded.
		Note: This only makes sense if you also increase the maximum action points with that same skill, otherwise they can clamped again during the next onUpdate loop
	@return actual amount of ActionPoints recovered
	*/
	q.recoverActionPoints <- function( _amount, _printLog = true, _canExceedMaximum = false )
	{
		if (_amount <= 0) return;

		local oldActionPoints = this.getActionPoints();

		if (_canExceedMaximum)
		{
			this.setActionPoints(this.getActionPoints() + _amount);
		}
		else
		{
			this.setActionPoints(::Math.min(this.getActionPointsMax(), this.getActionPoints() + _amount));
		}

		local recoveredActionPoints = this.getActionPoints() - oldActionPoints;
		if (_printLog && recoveredActionPoints > 0 && this.isPlacedOnMap() && this.getTile().IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this) + " recovers " + ::MSU.Text.colorPositive(recoveredActionPoints) + " Action Points");
		}

		return recoveredActionPoints;
	}

	// Get the usable fatigue, that this brother has, for using skills and such
	q.HD_getUsableFatigue <- function()
	{
		return this.getFatigueMax() - this.getFatigue();
	}

	// Try to adjust the current fatigue of this brother so that he has _usableFatigue usable fatigue
	q.HD_setUsableFatigue <- function( _usableFatigue )
	{
		this.setFatigue(this.getFatigueMax() - _usableFatigue);
	}

	q.HD_getChanceToBeHit <- function()
	{
		return this.m.HD_ChanceToBeHit;
	}

	// Toggle the Hitchance Overlay on- or off, depending on whether _skillId is "" or an actual skillId
	q.HD_toggleHitchanceOverlay <- function( _skillId )
	{
		if (!::Hardened.Mod.ModSettings.getSetting("DisplayHitchanceOverlays").getValue()) return;

		::Hardened.Private.IsPreviewingAttackWithHitChance = false;
		if (_skillId == "")	// We stop previewing a skill
		{
			// We turn off the ChanceToBeHit of all actors on the battlefield
			foreach (actor in ::Tactical.Entities.getAllInstancesAsArray())
			{
				actor.m.HD_ChanceToBeHit = null;
			}
		}
		else
		{
			// Todo: make sub function?
			foreach (skill in this.getSkills().m.Skills)
			{
				if (skill.getID() != _skillId) continue;
				// We found the skill to be highlighted!

				if (!skill.isAttack()) return;	// Non-Attacks have no hitchance to display
				if (!skill.isUsingHitchance()) return;

				::Hardened.Private.IsPreviewingAttackWithHitChance = true;
				foreach (otherActor in ::Tactical.Entities.getAllInstancesAsArray())
				{
					if (!otherActor.isPlacedOnMap()) continue;
					if (skill.isUsableOn(otherActor.getTile()))
					{
						otherActor.m.HD_ChanceToBeHit = skill.getHitchance(otherActor);
					}
				}

				break;
			}
		}

		::Tactical.State.m.TacticalScreen.getOrientationOverlayModule().HD_fullUpdateHitchanceOverlays();
	}

	// Recover hitpoints up to the maximum and return the amount of hitpoints that were recovered
	// _hitpoints are being scaled by the character property 'HitpointRecoveryMult'
	// @return amount of hitpoints recovered
	q.recoverHitpoints <- function( _hitpointsToRecover, _printLog = false )
	{
		if (_hitpointsToRecover <= 0.0) return 0;
		if (this.getHitpoints() == this.getHitpointsMax()) return 0;

		_hitpointsToRecover = _hitpointsToRecover * this.getCurrentProperties().HitpointRecoveryMult;
		_hitpointsToRecover += this.m.HD_recoveredHitpointsOverflow;

		local flooredRecoveredHitpoints = ::Math.floor(_hitpointsToRecover);
		this.m.HD_recoveredHitpointsOverflow = _hitpointsToRecover - flooredRecoveredHitpoints;

		// Never recover more hitpoints than the maximum hitpoints
		flooredRecoveredHitpoints = ::Math.min(flooredRecoveredHitpoints, this.getHitpointsMax() - this.getHitpoints());

		this.m.Hitpoints = this.getHitpoints() + flooredRecoveredHitpoints;

		if (_printLog && ::MSU.Utils.hasState("tactical_state") && flooredRecoveredHitpoints > 0 && this.isPlacedOnMap() && !this.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this) + " recovers " + ::MSU.Text.colorPositive(flooredRecoveredHitpoints) + " Hitpoints");
		}

		this.onUpdateInjuryLayer();

		return flooredRecoveredHitpoints;
	}

	// Helper function for figuring out, whether an _entity counts as surrounding for us
	// This does not check for the distance between both entities, so that needs to be checked beforehand
	// @param _entity is the actor that is potentially surrounding us. That actor is expected to be placed on map
	// Important: _entity as well as ourselves must be placed on map. Otherwise this function will throw an error
	q.countsAsSurrounding <- function( _entity )
	{
		if (::Math.abs(this.getTile().Level - _entity.getTile().Level) > 1) return false;

		if (_entity.isAlliedWith(this)) return false;
		if (_entity.isNonCombatant()) return false;
		if (_entity.getCurrentProperties().IsStunned) return false;
		if (_entity.isArmedWithRangedWeapon()) return false;

		return true;
	}

	// We are an NPC that is deemed to belong to a certain player-possible banner (most likely because of mercenary company)
	// This function will find that bannerID by all means necessary and if it can't it will return -1
	// @return unsigned integer bannerID if a banner could be found
	// @return -1 if no banner was found
	q.findAppropriateBannerID <- function()
	{
		/*
		1. this is part of a world party, which uses a mercenary banner -> we use that merc banner
			-> we use that merc banner
		2. this is part of a world party, which uses a non-mercenary banner
			-> use random merc banner? If so, how do we make sure all of them use the same banner?
			- do no coloring?
		3. this is hostile to the player and at least one of the hostile banners from this combat is a mercenary one
			-> we color our shield in a random hostile player banner from the combat properties
		*/

		// First we check, if this actor belongs to a world party
		local party = this.getParty();
		if (party != null)	// We belong to a world party
		{
			local bannerID = this.getWorldTroop().Party.getBannerID();
			if (bannerID != -1)		// If that world party has a usable banner
			{
				return bannerID;
			}
		}

		local stratProps = ::Tactical.State.getStrategicProperties();
		if (stratProps != null)
		{
			local bannerPool = this.isAlliedWithPlayer() ? stratProps.AllyBanners : stratProps.EnemyBanners;

			foreach (banner in bannerPool)
			{
				if (banner == ::World.Assets.getBanner()) continue;	// The Banner used by the Player is reserved

				local stringIndex = banner.find("banner_");
				try {	// Non-player banner used here will throw errors
					return banner.slice(stringIndex + 7).tointeger();	// +7 because "banner_" are 7 characters and we wanna point to the first character after this
				}
				catch (err) {}	// Do nothing
			}
		}

		return -1;	// We didn't find a good candidate
	}

	// Try to paint each shield equipped to this actor in the colors of its appropriate banner
	// The banner is fetched via the new findAppropriateBannerID function by "all means necessary"
	q.paintShieldsInCompanyColors <- function()
	{
		foreach (offhandItem in this.getItems().getAllItemsAtSlot(::Const.ItemSlot.Offhand))
		{
			if (offhandItem.isItemType(::Const.Items.ItemType.Shield))
			{
				offhandItem.paintInCompanyColors(this.findAppropriateBannerID());
			}
		}
	}

// Private Functions
	// Helper function to calculate the amount of surrounding characters in a more moddable way
	q.__calculateSurroundedCount <- function()
	{
		if (!this.isPlacedOnMap()) return 0;

		local count = 0;

		// Copy of the Vanilla surround calculation
		foreach (nextTile in ::MSU.Tile.getNeighbors(this.getTile()))
		{
			if (nextTile.IsOccupiedByActor && this.countsAsSurrounding(nextTile.getEntity()))
			{
				++count;
			}
		}

		return count;
	}

	// only meant for converting instances of vanilla hitpoint recovery to utilize our new system
	q.__recoverHitpointsSwitcheroo <- function( _hitpointsToRecover )
	{
		if (!::MSU.Utils.hasState("tactical_state"))	// Outside of battle we can't generate combat logs so there are no logs we need to prevent from showing
		{
			this.recoverHitpoints(_hitpointsToRecover);
			return;
		}

		this.recoverHitpoints(_hitpointsToRecover, true);

		// We do a switcheroo on the log function from the combat log to prevent the very next attempt of Vanilla to produce their own combat log for hitpoints recovered
		// That is important because with the new HitpointRecoveryMult property that log can be wrong
		// Instead we print our or own correct combat log
		local combatLog = ::Tactical.State.m.TacticalScreen.m.TopbarEventLog;
		local oldLog = combatLog.log;
		combatLog.log = function( _text )
		{
			if (_text.find("" + _hitpointsToRecover) != null)
			{
				// do nothing - The very next time, that Vanilla wants to print a combat log containing _hitpointsToRecover, we prevent that
			}
			else
			{
				oldLog(_text);
			}

			combatLog.log = oldLog;	// Revert the vanilla log function to what it was before
		}
	}

	// This actor has possibly changed the tile situation on the battlefield, by spawning in or moving, so we check who we need to update because of this fact
	q.__possiblyChangedTileSituation <- function()
	{
		foreach (actor in ::Tactical.Entities.getAllInstancesAsArray())
		{
			if (this.getID() == actor.getID()) continue;	// This update would be redundant so we skip it for performance reasons
			if (actor.getCurrentProperties().UpdateWhenTileOccupationChanges)
			{
				actor.getSkills().update();	// This will allow certain skills to react to the movement of other characters on the battlefield
			}
		}
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
	q.generateCorpse = @(__original) function( _tile, _fatalityType, _killer )
	{
		local ret = __original(_tile, _fatalityType, _killer);
		ret.HD_FatalityType = _fatalityType;
		return ret;
	}

	q.onInit = @(__original) function()
	{
		__original();

		// Feat: we fully fill Action Points and Hitpoints after everything has been initialized. That way we can save two lines in every NPC implementation
		if (!::MSU.isKindOf(this, "player"))	// The player gets these stat adjustments applied in a different way
		{
			local b = this.getBaseProperties();
			this.m.ActionPoints = b.ActionPoints;
			this.m.Hitpoints = b.Hitpoints;
			this.m.CurrentProperties = clone b;	// Feat: we initialize the CurrentProperties once. That way we can save one line in every NPC implementation
		}
	}

	// For Vanilla you'd hook onActorKilled on player.nut. But Reforged moved the exp calculation over into the onDeath of actor.nut
	// Reforged adds its XP at the start of onDeath via hookTree, so in order to still be earlier, we need to do the same
	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		local oldGlobalXPMult = ::Const.Combat.GlobalXPMult;
		if (!this.m.GrantsXPOnDeath) ::Const.Combat.GlobalXPMult = 0;

		__original(_killer, _skill, _tile, _fatalityType);

		::Const.Combat.GlobalXPMult = oldGlobalXPMult;
	}

	// Assign all regular Equipment that this character brings into battle BEFORE any other assign equipment logic runs
	//	That way custom-gear code can react to these basic assignments
	q.assignRandomEquipment = @(__original) function()
	{
		if (this.m.ChestWeightedContainer != null && this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
		{
			if (::Math.rand(1, 100) > this.m.ChanceForNoChest)
			{
				this.getItems().equip(::new(this.m.ChestWeightedContainer.roll()));
			}
		}

		if (this.m.HelmetWeightedContainer != null && this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
		{
			if (::Math.rand(1, 100) > this.m.ChanceForNoHelmet)
			{
				this.getItems().equip(::new(this.m.HelmetWeightedContainer.roll()));
			}
		}

		// We assume that the offhand is always empty if the mainhand is empty
		if (this.m.WeaponWeightContainer != null && this.getItems().hasEmptySlot(::Const.ItemSlot.Mainhand))
		{
			if (::Math.rand(1, 100) > this.m.ChanceForNoWeapon)
			{
				this.getItems().equip(::new(this.m.WeaponWeightContainer.roll()));
			}
		}

		if (this.m.OffhandWeightContainer != null && this.getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
		{
			if (::Math.rand(1, 100) > this.m.ChanceForNoOffhand)
			{
				this.getItems().equip(::new(this.m.OffhandWeightContainer.roll()));
			}
		}

		__original();
	}

// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.__possiblyChangedTileSituation();
	}
});
