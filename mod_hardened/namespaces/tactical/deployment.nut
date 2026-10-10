
::Hardened.Tactical.EngagementType <- {
	/// Player and enemy face each other from opposite sides of the battlefield.
	/// Allies spawn on top of player
	/// Up to 2 different factions may take up spawns top and bottom
	LineBattle = "HD_Line_Battle",

	/// Player joins an ongoing battle between two opposing participants.
	/// Up to 5 additional non-fighting participants may join on top of that
	/// Allies spawn top or bottom of player at border
	JoinBattle = "HD_Join_Battle",

	/// Player is surrounded by an enemy participant.
	GetAmbushed = "HD_Get_Ambushed",

	/// Player surrounds an enemy participant.
	DoAmbush = "HD_Do_Ambush",

	/// Player deploys at the edge while enemies are distributed across the battlefield.
	FightInfestation = "HD_Fight_Infestation",

	/// Player attacks an enemy defending a fortified deployment area.
	AttackFortification = "HD_Attack_Fortification",

	/// Player defends a fortified deployment area against an attacking enemy and spawns outside of the walls
	DefendFortification = "HD_Defend_Fortification",

	/// Player defends a fortified deployment area against an attacking enemy and spawns outside of the walls
	// "ProtectingCaravan",

	/// Deployment regions are defined manually instead of using a predefined engagement layout.
	Custom = "HD_Custom",
};

::Hardened.Tactical.Deployment <- {

}


// DeploymentPlan

/// This namespaces uses the Vanilla CombatInfo and compiles Participants and EngagementType from it
/// It then creates Regions according to the EngagementType and amount of Participants and places as many Participants on them as it can fit
::Hardened.Tactical.Deployment <- {
	RegionPlan = {
		m = {
		// Required:
			Player = null,			// Region reserved for the player
			PersonalAlly = null,	// Ally spawning directly alongside the player
			Default = [],			// Normal participant placement. Front: Enemies; Back: Allies
		// Optional:
			Defender = null,		// Defender of a location
		}

		function clear()
		{
			this.Player = null;
			this.PersonalAlly = null;
			this.Default = [];
			this.Defender = null;
		},
	}

	Participants = {	// A participant is a faction
		m = {
			Player = [],
			EngagedEnemies = [],
			EngagedAllies = [],
			Enemies = [],
			Allies = [],
		}

		function clear()
		{
			foreach (key, _ in this.m)
			{
				this.m[key] = [];
			}
		},
		function getAll()
		{
			local allParticipants = [];
			foreach (participants in this.m)
			{
				allParticipants.extend(participants)
			}
			return allParticipants;
		},
	},
	EngagementType = null,

	PreparedRegions = {

	}
	/*
	DeploymentRegion = {
		Region = null,

	}*/

	// public
		/// Must be called once per combat during the startCombat function (so that we can still fetch isInCombat() property of parties correctly)
		/// @param _combatInfo vanilla combat properties instance of ::Const.Tactical.CombatInfo
		function init( _combatInfo )
		{
			this.Participants.clear();
			this.preparePlayerCharacters(_combatInfo);
			this.prepareAIParticipants(_combatInfo);

			this.EngagementType = _combatInfo.HD_EngagementType != null ? _combatInfo.HD_EngagementType : this.generateEngagementType(_combatInfo);
		}

		// Must be called once per combat during the spawn() function
		function spawn()
		{
			this.deployParticipants();
		}

	// Private
		/// Compile a list of all characters that will field under the player banner
		/// @return array of player characters (+ guests)
		function preparePlayerCharacters( _properties )
		{
			::World.Assets.updateFormation();

			local playerParticipant = ::Hardened.Tactical.Participant.create();
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

			this.Participants.m.Player = playerParticipant;
		}

		// Non-Player Participant Merging
		// Compile "Participants" out of the non-player Parties from _combatInfo. Each faction results in at most one Participant
		function prepareAIParticipants( _combatInfo )
		{
			::logWarning("Hardened: prepareAIParticipants sort");
			// Sort parties to get the same factions grouped together
			// _combatInfo.Entities.sort(::Tactical.Entities.onFactionCompare);

			local lastFaction = null;
			local lastCombatState = null;
			local currentParticipant = null;

			local participatingAIFactions = [];
			::logWarning("Hardened: foreach (troop in _combatInfo.Entities)");
			foreach (party in _combatInfo.Parties)
			{
				::MSU.Log.printData(party, 2);
				// local party = troopDef.Party;

				// Is this is a party from a faction we haven't had yet, we sort the current entry
				//	and create a new entry
				::logWarning("Hardened: if");
				if (lastFaction != party.getFaction() || lastCombatState != party.isInCombat())
				{
					lastFaction = party.getFaction();
					lastCombatState = party.isInCombat();

					// Store the previous entry
					if (currentParticipant != null)
					{
						this.registerParticipant(currentParticipant);
					}

					// Create a new participant
					currentParticipant = ::Hardened.Tactical.Participant.create();
					currentParticipant.Faction = party.getFaction();
					currentParticipant.IsAlliedWithPlayer = party.isAlliedWithPlayer();
					currentParticipant.InCombatAlready = party.isInCombat();

					if (_combatInfo.LocationTemplate != null && ::World.FactionManager.isAllied(currentParticipant.Faction, _combatInfo.LocationTemplate.OwnedByFaction))
					{
						currentParticipant.IsOwningLocation = true;
					}
				}

				currentParticipant.Parties.push(party);
			}

			this.registerParticipant(currentParticipant);
		}

		// We assume that Auto means both player and opponent are set as auto
		function translateAutoEngagementType( _combatInfo )
		{
			if (!::MSU.isNull(::World.State.getEscortedEntity()))
			{
				return ::Hardened.Tactical.EngagementType.ProtectingCaravan;
			}

			if (_combatInfo.LocationTemplate != null)
			{
				if (_combatInfo.LocationTemplate.ForceLineBattle)
				{
					// We fight in the center of the camp
					return ::Hardened.Tactical.EngagementType.LineBattle;
				}
				else if (_combatInfo.HD_IsFightingAtLocation && _combatInfo.LocationTemplate.Fortification != ::Const.Tactical.FortificationType.None)
				{
					if (::Const.Tactical.CombatInfo.HD_IsAttackingLocation)
					{
						return ::Hardened.Tactical.EngagementType.AttackFortification;
					}
					else
					{
						return ::Hardened.Tactical.EngagementType.DefendFortification;
					}
				}
			}

			if (_combatInfo.InCombatAlready)
			{
				return ::Hardened.Tactical.EngagementType.JoinBattle;
			}

			// Some terrain types force a line battle, even if the enemy engages us
			if (::Const.World.TerrainTypeLineBattle[_combatInfo.Tile.Type])
			{
				return ::Hardened.Tactical.EngagementType.LineBattle;
			}

			if (!_combatInfo.IsPlayerInitiated)
			{
				return ::Hardened.Tactical.EngagementType.GetAmbushed;
			}

			// Default
			return ::Hardened.Tactical.EngagementType.LineBattle;
		}

		/// Sort a given _participant into the this.Participants.m Table, depending on its characteristics
		function registerParticipant( _participant )
		{
			if (_participant.InCombatAlready)
			{
				if (_participant.IsAlliedWithPlayer)
				{
					::logWarning("Hardened: found EngagedAllies participant");
					this.Participants.m.EngagedAllies.push(_participant);
				}
				else
				{
					::logWarning("Hardened: found EngagedEnemies participant");
					this.Participants.m.EngagedEnemies.push(_participant);
				}
			}
			else
			{
				if (_participant.IsAlliedWithPlayer)
				{
					::logWarning("Hardened: found Allies participant");
					this.Participants.m.Allies.push(_participant);
				}
				else
				{
					::logWarning("Hardened: found Enemies participant");
					this.Participants.m.Enemies.push(_participant);
				}
			}
		}

		/// Generate the fitting engagement type for a combat, given the vanilla _combatInfo
		/// @return ::Hardened.Tactical.EngagementType
		function generateEngagementType( _combatInfo )
		{
			if (_combatInfo.PlayerDeploymentType == ::Const.Tactical.DeploymentType.Auto)
			{
				return this.translateAutoEngagementType(_combatInfo);
			}

			if (_combatInfo.DeploymentType == ::Const.Tactical.DeploymentType.Random)
			{
				return ::Hardened.Tactical.EngagementType.FightInfestation;
			}

			if (_combatInfo.DeploymentType == ::Const.Tactical.DeploymentType.Circle)
			{
				if (_combatInfo.PlayerDeploymentType == ::Const.Tactical.DeploymentType.Edge)
				{
					// E.g. break_greenskin_siege_contract
					return ::Hardened.Tactical.EngagementType.FightInfestation;
				}
				else
				{
					// E.g. decisive_battle_contract, deliver_item_contract, destroy_goblin_camp_contract
					// In Vanilla some of these, spawn the player in Line still, keeping some of their formation alive. We streamline it to always and up in a circle
					return ::Hardened.Tactical.EngagementType.GetAmbushed;
				}
			}

			return ::Hardened.Tactical.EngagementType.LineBattle;
		}

		/// Go through Participants according to EngagementType, create Regions for each of them and trigger the spawning on those Regions
		function deployParticipants()
		{
			::logWarning("Hardened: this.EngagementType " + this.EngagementType);
			switch (this.EngagementType)
			{
				case ::Hardened.Tactical.EngagementType.LineBattle:
				{
					::logWarning("Hardened: case ::Hardened.Tactical.EngagementType.LineBattle");
					local offsetX = 3;
					local mainEnemyRegions = [];
					::logWarning("Hardened: " + this.Participants.m.Enemies.len() + " Enemies");
					if (this.Participants.m.Enemies.len() == 1)
					{
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 180 }));
					}
					else if (this.Participants.m.Enemies.len() == 2)
					{
						offsetX = 5;
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 120 }));
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 240 }));
					}
					else
					{
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 180 }));
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = 10, Rotation = 90 }));
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = 10, Rotation = 270 }));
					}

					local playerRegion = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -offsetX });
					::Hardened.Tactical.Region.placePlayersInFormation(this.Participants.m.Player.Entities, playerRegion);

					foreach (index, region in mainEnemyRegions)
					{
						if (index >= this.Participants.m.Enemies.len()) break;
						local enemyParticipant = this.Participants.m.Enemies[index];
						::Hardened.Tactical.Region.placeNPCsInFormation(enemyParticipant.getTroopDefs(), region);
					}

					// alliedRegion.excludeRegion(playerRegion);
					local mainAllyRegions = [];
					mainAllyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX }));
					mainAllyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX -5 }));
					mainAllyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX -10 }));

					::logWarning("Hardened: this.Participants.m.Allies.len() " + this.Participants.m.Allies.len());

					foreach (index, region in mainAllyRegions)
					{
						if (index >= this.Participants.m.Allies.len()) break;
						local allyParticipant = this.Participants.m.Allies[index];
						::Hardened.Tactical.Region.placeNPCsInFormation(allyParticipant.getTroopDefs(), region);
					}

					break;
				}
				case ::Hardened.Tactical.EngagementType.JoinBattle:
				{
					::logWarning("Hardened: case ::Hardened.Tactical.EngagementType.JoinBattle");
					local offsetX = 2;

					local combinedEngagedParticipants = [];
					local maxIndex = ::Math.max(this.Participants.m.EngagedEnemies.len(), this.Participants.m.EngagedAllies.len());
					for (local index = 0; index <= maxIndex; ++index)
					{
						// We do a mix of both types of parties to guarantee
						if (index < this.Participants.m.EngagedAllies.len())
						{
							combinedEngagedParticipants.push(this.Participants.m.EngagedAllies[index]);
						}
						if (index < this.Participants.m.EngagedEnemies.len())
						{
							combinedEngagedParticipants.push(this.Participants.m.EngagedEnemies[index]);
						}
					}

					local mixedEngagedRegions = [];
					if (combinedEngagedParticipants.len() <= 2)
					{
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 90 }));
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 270 }));
					}
					else
					{
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 0 }));
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 180 }));
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = 8, Rotation = 90 }));
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = 8, Rotation = 270 }));
					}

					local mixedIndex = 0;
					foreach (region in mixedEngagedRegions)
					{
						if (mixedIndex >= combinedEngagedParticipants.len()) break;

						local participant = combinedEngagedParticipants[mixedIndex];
						::Hardened.Tactical.Region.placeNPCsInFormation(participant.getTroopDefs(), region);
						++mixedIndex;
					}

					local playerRegion = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -13 });
					::Hardened.Tactical.Region.placePlayersInFormation(this.Participants.m.Player.Entities, playerRegion);

					if (this.Participants.m.Allies.len() >= 1)
					{
						local enemyRegion = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -12, Rotation = 0 });
						::Hardened.Tactical.Region.placeNPCsInFormation(this.Participants.m.Allies[0].getTroopDefs(), enemyRegion);
					}

					if (this.Participants.m.EngagedEnemies.len() >= 1)
					{
						local enemyRegion = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -12, Rotation = 180 });
						::Hardened.Tactical.Region.placeNPCsInFormation(this.Participants.m.EngagedEnemies[0].getTroopDefs(), enemyRegion);
					}

					break;
				}
				default:
					::logWarning("Hardened: Unknown EngagementType: " + this.EngagementType);
			}
		}

		function generateRegionPlan()
		{
			this.RegionPlan.clear();
			this.generatePlayerRegion();
			this.RegionPlan.m.Default = this.generateDefaultRegions();
			this.RegionPlan.m.Defender = this.generateDefenderRegion();
		}

		function generatePlayerRegion()
		{
			switch (this.EngagementType)
			{
				case ::Hardened.Tactical.EngagementType.LineBattle:
				{
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -3 });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 6, 12, { OffsetX = -3 });
				}
				case ::Hardened.Tactical.EngagementType.JoinBattle:
				{
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -13 });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13 });
				}
				default:
					::logWarning("Hardened: Unsupported EngagementType: " + this.EngagementType);
			}
			return null;
		}

		function generateDefaultRegions()
		{
			// This array is structure in this way
			// CombatRegions -> EnemyRegions -> AllyRegions
			local defaultRegions = [];
			switch (this.EngagementType)
			{
				case ::Hardened.Tactical.EngagementType.LineBattle:
				{
					// Center Right (extra large region)
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 6, 12, { OffsetX = -3, Rotation = 180 }));
					// Top
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
					// Bottom
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));
					// Far Right
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13, Rotation = 180 }));
					// Far Left
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13 }));
				}
				case ::Hardened.Tactical.EngagementType.JoinBattle:
				{
					// Top
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -2, Rotation = 90 }));
					// Bottom
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -2, Rotation = 270 }));
					// Right
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -7, Rotation = 180 }));

					// Far Top
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
					// Far Right
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13, Rotation = 180 }));
					// Far Bottom
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));

					// Far Left
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13 }));


					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -13 });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13 });
				}
				default:
					::logWarning("Hardened: Unsupported EngagementType: " + this.EngagementType);
			}
			return defaultRegions;
		}

		function generateNPCRegions()
		{
			switch (_engagementType)
			{
				case ::Hardened.Tactical.EngagementType.LineBattle:
				{
					::logWarning("Hardened: case ::Hardened.Tactical.EngagementType.LineBattle");
					local offsetX = 3;
					local mainEnemyRegions = [];
					::logWarning("Hardened: " + this.Participants.m.Enemies.len() + " Enemies");
					if (this.Participants.m.Enemies.len() == 1)
					{
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 180 }));
					}
					else if (this.Participants.m.Enemies.len() == 2)
					{
						offsetX = 5;
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 120 }));
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 240 }));
					}
					else
					{
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 180 }));
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = 10, Rotation = 90 }));
						mainEnemyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = 10, Rotation = 270 }));
					}

					local playerRegion = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -offsetX });
					::Hardened.Tactical.Region.placePlayersInFormation(this.Participants.m.Player.Entities, playerRegion);

					foreach (index, region in mainEnemyRegions)
					{
						if (index >= this.Participants.m.Enemies.len()) break;
						local enemyParticipant = this.Participants.m.Enemies[index];
						::Hardened.Tactical.Region.placeNPCsInFormation(enemyParticipant.getTroopDefs(), region);
					}

					// alliedRegion.excludeRegion(playerRegion);
					local mainAllyRegions = [];
					mainAllyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX }));
					mainAllyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX -5 }));
					mainAllyRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX -10 }));

					::logWarning("Hardened: this.Participants.m.Allies.len() " + this.Participants.m.Allies.len());

					foreach (index, region in mainAllyRegions)
					{
						if (index >= this.Participants.m.Allies.len()) break;
						local allyParticipant = this.Participants.m.Allies[index];
						::Hardened.Tactical.Region.placeNPCsInFormation(allyParticipant.getTroopDefs(), region);
					}

					break;
				}
				case ::Hardened.Tactical.EngagementType.JoinBattle:
				{
					::logWarning("Hardened: case ::Hardened.Tactical.EngagementType.JoinBattle");
					local offsetX = 2;

					local combinedEngagedParticipants = [];
					local maxIndex = ::Math.max(this.Participants.m.EngagedEnemies.len(), this.Participants.m.EngagedAllies.len());
					for (local index = 0; index <= maxIndex; ++index)
					{
						// We do a mix of both types of parties to guarantee
						if (index < this.Participants.m.EngagedAllies.len())
						{
							combinedEngagedParticipants.push(this.Participants.m.EngagedAllies[index]);
						}
						if (index < this.Participants.m.EngagedEnemies.len())
						{
							combinedEngagedParticipants.push(this.Participants.m.EngagedEnemies[index]);
						}
					}

					local mixedEngagedRegions = [];
					if (combinedEngagedParticipants.len() <= 2)
					{
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 90 }));
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 270 }));
					}
					else
					{
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 0 }));
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -offsetX, Rotation = 180 }));
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = 8, Rotation = 90 }));
						mixedEngagedRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = 8, Rotation = 270 }));
					}

					local mixedIndex = 0;
					foreach (region in mixedEngagedRegions)
					{
						if (mixedIndex >= combinedEngagedParticipants.len()) break;

						local participant = combinedEngagedParticipants[mixedIndex];
						::Hardened.Tactical.Region.placeNPCsInFormation(participant.getTroopDefs(), region);
						++mixedIndex;
					}

					local playerRegion = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -13 });
					::Hardened.Tactical.Region.placePlayersInFormation(this.Participants.m.Player.Entities, playerRegion);

					if (this.Participants.m.Allies.len() >= 1)
					{
						local enemyRegion = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -12, Rotation = 0 });
						::Hardened.Tactical.Region.placeNPCsInFormation(this.Participants.m.Allies[0].getTroopDefs(), enemyRegion);
					}

					if (this.Participants.m.EngagedEnemies.len() >= 1)
					{
						local enemyRegion = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -12, Rotation = 180 });
						::Hardened.Tactical.Region.placeNPCsInFormation(this.Participants.m.EngagedEnemies[0].getTroopDefs(), enemyRegion);
					}

					break;
				}
				default:
					::logWarning("Hardened: Unknown EngagementType: " + this.EngagementType);
			}
		}
}
