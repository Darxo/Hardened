/// This namespaces uses the Vanilla CombatInfo and compiles Participants and EngagementType from it
/// It then creates Regions according to the EngagementType and amount of Participants and places as many Participants on them as it can fit
::Hardened.Deployment.DeploymentManager <- {
	EngagementType = null,
	RegionPlan = null,
	ParticipantCollection = null,

	HasBeenInitialized = false,

// public
	/// Must be called once per combat during the startCombat function (so that we can still fetch isInCombat() property of parties correctly)
	/// @param _combatInfo vanilla combat properties instance of ::Const.Tactical.CombatInfo
	function init( _combatInfo )
	{
		this.EngagementType = _combatInfo.HD_EngagementType != null ? _combatInfo.HD_EngagementType : this.generateEngagementType(_combatInfo);
		::logInfo("Hardened: Deployment init EngagementType " + this.EngagementType);

		if (this.EngagementType != ::Hardened.Deployment.EngagementType.Custom)
		{
			this.ParticipantCollection = ::Hardened.Deployment.ParticipantCollection();
			this.prepareAIParticipants(_combatInfo);
			this.ParticipantCollection.sort();
		}

		this.HasBeenInitialized = true;
	}
	// Must be called once per combat during the spawn() function
	function spawn( _combatInfo )
	{
		::logInfo("Hardened: Deployment spawn " + _combatInfo);
		if (!this.HasBeenInitialized)
		{
			::logWarning("Hardened: DeploymentManager.spawn() was called without a previous init()");
			return;
		}

		if (this.EngagementType != ::Hardened.Deployment.EngagementType.Custom)
		{
			this.preparePlayerCharacters(_combatInfo);
			this.generateRegionPlan(_combatInfo);
			this.deployParticipants();

			local unplacedParticipants = this.ParticipantCollection.npcParticipantCount();
			if (unplacedParticipants > 0)
			{
				::logWarning("Hardened: " + unplacedParticipants + " Participants could not be placed because there was no space for them");
			}
		}

		this.HasBeenInitialized = false;
	}

// Private
	/// Compile a list of all characters that will field under the player banner
	/// @return array of player characters (+ guests)
	function preparePlayerCharacters( _properties )
	{
		::World.Assets.updateFormation();

		local playerParticipant = ::Hardened.Deployment.Participant();
		local all_players = _properties.IsUsingSetPlayers ? _properties.Players : ::World.getPlayerRoster().getAll();
		foreach (brother in all_players)
		{
			if (!_properties.IsUsingSetPlayers && brother.getPlaceInFormation() >= ::World.Assets.m.HD_FormationSlots)
			{
				continue;
			}

			// The following mechanic is removed/reverted in Hardened. But we keep it for now
			local items = brother.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);
			foreach (item in items)
			{
				if ("setLoaded" in item)
				{
					item.setLoaded(false);
				}
			}

			playerParticipant.Entities.push(brother);
			if (playerParticipant.Entities.len() >= ::World.Assets.getBrothersMaxInCombat()) break;
		}

		if (::World.State.isUsingGuests() && ::World.getGuestRoster().getSize() != 0)
		{
			playerParticipant.Entities.extend(::World.getGuestRoster().getAll());
		}

		this.ParticipantCollection.Player = playerParticipant;
	}

	// Non-Player Participant Merging
	// Compile "Participants" out of the non-player Parties from _combatInfo. Each faction results in at most one Participant
	function prepareAIParticipants( _combatInfo )
	{
		// Sort parties to get the same factions grouped together
		local lastFaction = null;
		local lastCombatState = null;
		local currentParticipant = null;

		local participatingAIFactions = [];

		_combatInfo.Entities.sort(this.onFactionCompare);
		// We need to loop through
		foreach (troopDef in _combatInfo.Entities)
		{
			local isInCombat = "Party" in troopDef ? troopDef.Party.isInCombat() : false;

			// Is this is a troop from a faction we haven't had yet, we create a new participant and sort its troops into it
			if (lastFaction != troopDef.Faction || lastCombatState != isInCombat)
			{
				lastFaction = troopDef.Faction;
				lastCombatState = isInCombat;

				// Store the previous entry
				if (currentParticipant != null)
				{
					this.ParticipantCollection.registerParticipant(currentParticipant);
				}

				// Create a new participant
				currentParticipant = ::Hardened.Deployment.Participant();
				currentParticipant.Faction = troopDef.Faction;
				currentParticipant.IsAlliedWithPlayer = ::World.FactionManager.isAlliedWithPlayer(troopDef.Faction);
				currentParticipant.InCombatAlready = isInCombat;

				local eType = ::Hardened.Deployment.EngagementType;

				if (this.EngagementType == eType.AttackFortification || this.EngagementType == eType.DefendFortification)
				{
					if (currentParticipant.Faction == _combatInfo.LocationTemplate.OwnedByFaction)
					{
						currentParticipant.IsLocationDefender = true;
					}
				}
			}

			currentParticipant.addTroopDef(troopDef);
		}

		this.ParticipantCollection.registerParticipant(currentParticipant);
	}

	// We assume that Auto means both player and opponent are set as auto
	function translateAutoEngagementType( _combatInfo )
	{
		if (_combatInfo.LocationTemplate != null)
		{
			if (_combatInfo.LocationTemplate.ForceLineBattle)
			{
				// We fight in the center of the camp
				return ::Hardened.Deployment.EngagementType.LineBattle;
			}
			else if (_combatInfo.HD_IsFightingAtLocation && _combatInfo.LocationTemplate.Fortification != ::Const.Tactical.FortificationType.None)
			{
				if (_combatInfo.HD_IsAttackingLocation)
				{
					return ::Hardened.Deployment.EngagementType.AttackFortification;
				}
				else
				{
					return ::Hardened.Deployment.EngagementType.DefendFortification;
				}
			}
		}

		if (_combatInfo.InCombatAlready)
		{
			return ::Hardened.Deployment.EngagementType.JoinBattle;
		}

		// Some terrain types force a line battle, even if the enemy engages us
		if (::Const.World.TerrainTypeLineBattle[_combatInfo.Tile.Type])
		{
			return ::Hardened.Deployment.EngagementType.LineBattle;
		}

		if (!_combatInfo.IsPlayerInitiated)
		{
			return ::Hardened.Deployment.EngagementType.GetAmbushed;
		}

		// Default
		return ::Hardened.Deployment.EngagementType.LineBattle;
	}

	/// Generate the fitting engagement type for a combat, given the vanilla _combatInfo
	/// @return ::Hardened.Deployment.EngagementType
	function generateEngagementType( _combatInfo )
	{
		if (_combatInfo.PlayerDeploymentType == ::Const.Tactical.DeploymentType.Auto)
		{
			return this.translateAutoEngagementType(_combatInfo);
		}

		if (_combatInfo.EnemyDeploymentType == ::Const.Tactical.DeploymentType.Random)
		{
			return ::Hardened.Deployment.EngagementType.FightInfestation;
		}

		if (_combatInfo.EnemyDeploymentType == ::Const.Tactical.DeploymentType.Circle)
		{
			if (_combatInfo.PlayerDeploymentType == ::Const.Tactical.DeploymentType.Edge)
			{
				// E.g. break_greenskin_siege_contract
				return ::Hardened.Deployment.EngagementType.FightInfestation;
			}
			else
			{
				// E.g. decisive_battle_contract, deliver_item_contract, destroy_goblin_camp_contract
				// In Vanilla some of these, spawn the player in Line still, keeping some of their formation alive. We streamline it to always and up in a circle
				return ::Hardened.Deployment.EngagementType.GetAmbushed;
			}
		}

		return ::Hardened.Deployment.EngagementType.LineBattle;
	}

	/// Go through Participants according to EngagementType, create Regions for each of them and trigger the spawning on those Regions
	function deployParticipants()
	{
	// Player
		::Hardened.Deployment.RegionManager.placePlayersInFormation(this.ParticipantCollection.Player.Entities, this.RegionPlan.Player);

	// Personal Ally
		if (this.RegionPlan.PersonalAlly != null && this.ParticipantCollection.Allies.len() > 0)
		{
			::Hardened.Deployment.RegionManager.placeNPCsInFormation(this.ParticipantCollection.Allies[0].getTroopDefs(), this.RegionPlan.PersonalAlly);
			this.ParticipantCollection.Allies.remove(0);
		}

	// Default
		// Place Defender
		if (this.RegionPlan.Default.len() > 0 && this.ParticipantCollection.Defender != null)
		{
			::Hardened.Deployment.RegionManager.placeNPCsInFormation(this.ParticipantCollection.Defender.getTroopDefs(), this.RegionPlan.Default[0]);
			this.RegionPlan.Default.remove(0);
		}

		// Prepare ParticipantsInCombat
		local participantsInCombat = [];
		while (this.ParticipantCollection.EngagedEnemies.len() > 0 || this.ParticipantCollection.EngagedAllies.len() > 0)
		{
			if (this.ParticipantCollection.EngagedEnemies.len() > 0)
			{
				participantsInCombat.push(this.ParticipantCollection.EngagedEnemies[0]);
				this.ParticipantCollection.EngagedEnemies.remove(0);
			}

			if (this.ParticipantCollection.EngagedAllies.len() > 0)
			{
				participantsInCombat.push(this.ParticipantCollection.EngagedAllies[0]);
				this.ParticipantCollection.EngagedAllies.remove(0);
			}
		}

		// Fill Combat Participants
		while (this.RegionPlan.Default.len() > 0 && participantsInCombat.len() > 0)
		{
			::Hardened.Deployment.RegionManager.placeNPCsInFormation(participantsInCombat[0].getTroopDefs(), this.RegionPlan.Default[0]);

			this.RegionPlan.Default.remove(0);
			participantsInCombat.remove(0);
		}

		// Fill Other Participants
		while (this.ParticipantCollection.Enemies.len() > 0 || this.ParticipantCollection.Allies.len() > 0)
		{
			if (this.RegionPlan.Default.len() == 0) break;

			if (this.ParticipantCollection.Enemies.len() > 0)
			{
				::Hardened.Deployment.RegionManager.placeNPCsInFormation(this.ParticipantCollection.Enemies[0].getTroopDefs(), this.RegionPlan.Default[0]);

				this.RegionPlan.Default.remove(0);
				this.ParticipantCollection.Enemies.remove(0);
			}

			if (this.RegionPlan.Default.len() == 0) break;

			if (this.ParticipantCollection.Allies.len() > 0)
			{
				local index = this.RegionPlan.Default.len() - 1;

				::Hardened.Deployment.RegionManager.placeNPCsInFormation(this.ParticipantCollection.Allies[0].getTroopDefs(), this.RegionPlan.Default[index]);

				this.RegionPlan.Default.remove(index);
				this.ParticipantCollection.Allies.remove(0);
			}
		}
	}

	function generateRegionPlan( _combatInfo )
	{
		this.RegionPlan = ::Hardened.Deployment.RegionPlan();
		this.generatePlayerRegion(_combatInfo);
		this.RegionPlan.Default = this.generateDefaultRegions(_combatInfo);
	}

	// We write our results into the member variables directly, because we generate two different regions
	function generatePlayerRegion( _combatInfo )
	{
		switch (this.EngagementType)
		{
			case ::Hardened.Deployment.EngagementType.LineBattle:
			{
				this.RegionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 2, 9, { OffsetX = -3 });
				this.RegionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 6, 12, { OffsetX = -3 });
				break;
			}
			case ::Hardened.Deployment.EngagementType.JoinBattle:
			{
				this.RegionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 2, 9, { OffsetX = -13 });
				this.RegionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -13 });
				break;
			}
			case ::Hardened.Deployment.EngagementType.AttackFortification:
			{
				local radius = ::Const.Tactical.Settings.CampRadius + _combatInfo.LocationTemplate.AdditionalRadius;
				local shiftX = _combatInfo.LocationTemplate.ShiftX;

				local offsetX = -6;
				offsetX -= radius;
				offsetX += shiftX;

				this.RegionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 2, 9, { OffsetX = offsetX });
				this.RegionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = offsetX });
				break;
			}
			case ::Hardened.Deployment.EngagementType.DefendFortification:
			{
				local radius = ::Const.Tactical.Settings.CampRadius + _combatInfo.LocationTemplate.AdditionalRadius;
				local shiftX = _combatInfo.LocationTemplate.ShiftX;

				local offsetX = -6;
				offsetX += radius;
				offsetX -= shiftX;

				this.RegionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 2, 9, { OffsetX = offsetX });
				this.RegionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = offsetX });
				break;
			}
			case ::Hardened.Deployment.EngagementType.GetAmbushed:
			{
				this.RegionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 0, 3);
				this.RegionPlan.Player.RandomPosition = true;
				this.RegionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 0, 3);
				this.RegionPlan.PersonalAlly.RandomPosition = true;
				break;
			}
			case ::Hardened.Deployment.EngagementType.DoAmbush:
			{
				this.RegionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 11, 12);
				this.RegionPlan.Player.RandomPosition = true;
				this.RegionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 11, 12);
				this.RegionPlan.PersonalAlly.RandomPosition = true;
				break;
			}
			case ::Hardened.Deployment.EngagementType.FightInfestation:
			{
				this.RegionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 2, 9, { OffsetX = -13 });
				this.RegionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -13 });
				break;
			}
			default:
				::logWarning("Hardened: Unsupported EngagementType: " + this.EngagementType + "! Defaulting to LineBattle");
				this.RegionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 2, 9, { OffsetX = -3 });
				this.RegionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 6, 12, { OffsetX = -3 });
				break;
		}
		return null;
	}

	function generateDefaultRegions( _combatInfo )
	{
		// This array is structure in this way
		// CombatRegions -> EnemyRegions -> AllyRegions
		local defaultRegions = [];
		switch (this.EngagementType)
		{
			case ::Hardened.Deployment.EngagementType.LineBattle:
			{
				// Center Right (extra large region)
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 6, 12, { OffsetX = -3, Rotation = 180 }));
				// Top
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
				// Bottom
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));
				// Far Right
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -13, Rotation = 180 }));
				// Far Left
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -13 }));
				break;
			}
			case ::Hardened.Deployment.EngagementType.JoinBattle:
			{
				// Top
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -2, Rotation = 90 }));
				// Bottom
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -2, Rotation = 270 }));
				// Right
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -7, Rotation = 180 }));

				// Far Top
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
				// Far Right
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -13, Rotation = 180 }));
				// Far Bottom
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));
				break;
			}
			case ::Hardened.Deployment.EngagementType.AttackFortification:
			{
				// Defender
				local radius = ::Const.Tactical.Settings.CampRadius + _combatInfo.LocationTemplate.AdditionalRadius;
				local shiftX = _combatInfo.LocationTemplate.ShiftX;
				local shiftY = _combatInfo.LocationTemplate.ShiftY;

				local defenderPortrait = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 6, 12, { OffsetX = radius - shiftX, OffsetY = -shiftY, Rotation = 180 });
				local defenderHexagon = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 0, radius, { OffsetX = shiftX, OffsetY = shiftY });
				defenderPortrait.intersectRegion(defenderHexagon);
				defenderPortrait.synchronizeSubRegions();
				defaultRegions.push(defenderPortrait);

				// Top
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
				// Bottom
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));
				// Far Left
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -13 }));
				break;
			}
			case ::Hardened.Deployment.EngagementType.DefendFortification:
			{
				// Defender
				local radius = ::Const.Tactical.Settings.CampRadius + _combatInfo.LocationTemplate.AdditionalRadius;
				local shiftX = _combatInfo.LocationTemplate.ShiftX;
				local shiftY = _combatInfo.LocationTemplate.ShiftY;
				local offsetX = radius - shiftX;
				local defenderPortrait = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = offsetX, OffsetY = -shiftY });
				local defenderHexagon = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 0, radius, { OffsetX = -shiftX, OffsetY = shiftY });
				defenderPortrait.intersectRegion(defenderHexagon);
				defenderPortrait.synchronizeSubRegions();
				defaultRegions.push(defenderPortrait);

				// Right (Main Attacker)
				local defenderOffsetX = -6;
				defenderOffsetX -= radius;
				defenderOffsetX += shiftX;
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = defenderOffsetX, Rotation = 180 }));
				// Top
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
				// Bottom
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));
				break;
			}
			case ::Hardened.Deployment.EngagementType.GetAmbushed:
			{
				local region = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 9, 10);
				region.RandomPosition = true;
				// Additional enemies and allies all spawn in the ring for simplicity reasons
				for (local n = 0; n < 10; ++n)
				{
					defaultRegions.push(region);
				}
				break;
			}
			case ::Hardened.Deployment.EngagementType.DoAmbush:
			{
				// The first 5 hostile parties will spawn in the center of the map
				local region = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 0, 5);
				region.RandomPosition = true;
				for (local n = 0; n < 5; ++n)
				{
					defaultRegions.push(region);
				}

				// The first 5 allied parties will spawn at the border together with the player
				local allyRegions = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 11, 12);
				region.RandomPosition = true;
				for (local n = 0; n < 5; ++n)
				{
					defaultRegions.push(allyRegions);
				}
				break;
			}
			case ::Hardened.Deployment.EngagementType.FightInfestation:
			{
				local region = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Hexagon, 0, 13, { OffsetX = 4 });
				region.RandomPosition = true;

				for (local n = 0; n < 10; ++n)
				{
					defaultRegions.push(region);
				}
				break;
			}
			default:
				// Center Right (extra large region)
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 6, 12, { OffsetX = -3, Rotation = 180 }));
				// Top
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
				// Bottom
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));
				// Far Right
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -13, Rotation = 180 }));
				// Far Left
				defaultRegions.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 12, { OffsetX = -13 }));
				break;
		}
		return defaultRegions;
	}

	// Exact of the vanilla ::Tactical.Entities.onFactionCompare function, because that global object is not yet available during initialisation
	function onFactionCompare( _e1, _e2 )
	{
		if (this.World.FactionManager.isAlliedWithPlayer(_e1.Faction) && !this.World.FactionManager.isAlliedWithPlayer(_e2.Faction))
		{
			return -1;
		}
		else if (!this.World.FactionManager.isAlliedWithPlayer(_e1.Faction) && this.World.FactionManager.isAlliedWithPlayer(_e2.Faction))
		{
			return 1;
		}
		else
		{
			if (_e1.Faction < _e2.Faction)
			{
				return -1;
			}
			else if (_e1.Faction > _e2.Faction)
			{
				return 1;
			}

			return 0;
		}
	}
}
