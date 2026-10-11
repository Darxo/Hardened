
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
	EngagementType = null,
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
			this.m.Player = null;
			this.m.PersonalAlly = null;
			this.m.Default = [];
			this.m.Defender = null;
		},
	},
	Participants = {	// A participant is a faction
		m = {
			Player = [],
			Defender = null,	// Party belonging to the location that the player attacks or defends
			EngagedEnemies = [],
			EngagedAllies = [],
			Enemies = [],
			Allies = [],
		}

		function npcParticipantCount()
		{
			local count = 0;
			count += this.m.EngagedAllies.len();
			count += this.m.EngagedEnemies.len();
			count += this.m.Allies.len();
			count += this.m.Enemies.len();
			return count;
		},

		function sort()
		{
			this.m.EngagedAllies.sort(this.onParticipantCompare);
			this.m.EngagedEnemies.sort(this.onParticipantCompare);
			this.m.Allies.sort(this.onParticipantCompare);
			this.m.Enemies.sort(this.onParticipantCompare);
		},
		function clear()
		{
			foreach (key, _ in this.m)
			{
				this.m[key] = [];
			}
			this.m.Defender = null;
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
		// Sort Participants so that the "strongest" one comes first. For know we determine this by party size
		function onParticipantCompare( _p1, _p2 )
		{
			// Particiapnt escorted by the player is always sorted to the front so it always takes the position by the player
			foreach (party in _p1.Parties)
			{
				if (::MSU.isEqual(party, ::World.State.getEscortedEntity()))
				{
					return -1;
				}
			}

			if (_p1.getTroopDefs().len() > _p2.getTroopDefs().len())
			{
				return -1;
			}
			else if (_p1.getTroopDefs().len() < _p2.getTroopDefs().len())
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	},

	// public
		/// Must be called once per combat during the startCombat function (so that we can still fetch isInCombat() property of parties correctly)
		/// @param _combatInfo vanilla combat properties instance of ::Const.Tactical.CombatInfo
		function init( _combatInfo )
		{
			::logInfo("Hardened: Deployment init");
			this.Participants.clear();
			this.preparePlayerCharacters(_combatInfo);
			this.prepareAIParticipants(_combatInfo);
			this.Participants.sort();

			this.EngagementType = _combatInfo.HD_EngagementType != null ? _combatInfo.HD_EngagementType : this.generateEngagementType(_combatInfo);
		}
		// Must be called once per combat during the spawn() function
		function spawn( _combatInfo )
		{
			::logInfo("Hardened: Try to deploy " + this.Participants.npcParticipantCount() + " Participants");
			this.generateRegionPlan(_combatInfo);
			this.deployParticipants();

			local unplacedParticipants = this.Participants.npcParticipantCount();
			if (unplacedParticipants > 0)
			{
				::logWarning("Hardened: " + unplacedParticipants + " Participants could not be placed because there was no space for them");
			}
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
			_combatInfo.Parties.sort(this.onFactionCompare);

			local lastFaction = null;
			local lastCombatState = null;
			local currentParticipant = null;

			local participatingAIFactions = [];
			::logWarning("Hardened: foreach (troop in _combatInfo.Entities)");
			foreach (party in _combatInfo.Parties)
			{
				// local party = troopDef.Party;

				// Is this is a party from a faction we haven't had yet, we sort the current entry
				//	and create a new entry
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

					if (_combatInfo.LocationTemplate != null && currentParticipant.Faction == _combatInfo.LocationTemplate.OwnedByFaction)
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
					if (_combatInfo.HD_IsAttackingLocation)
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
			if (_participant.IsOwningLocation)
			{
				::logWarning("Hardened: found defender participant");
				this.Participants.m.Defender = _participant;
				return;
			}

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

		// Player
			::Hardened.Tactical.Region.placePlayersInFormation(this.Participants.m.Player.Entities, this.RegionPlan.m.Player);

		// Personal Ally
			if (this.RegionPlan.m.PersonalAlly != null && this.Participants.m.Allies.len() > 0)
			{
				::Hardened.Tactical.Region.placeNPCsInFormation(this.Participants.m.Allies[0].getTroopDefs(), this.RegionPlan.m.PersonalAlly);
				this.Participants.m.Allies.remove(0);
			}

		// Default
			// Place Defender
			if (this.RegionPlan.m.Default.len() > 0 && this.Participants.m.Defender != null)
			{
				::Hardened.Tactical.Region.placeNPCsInFormation(this.Participants.m.Defender.getTroopDefs(), this.RegionPlan.m.Default[0]);
				this.RegionPlan.m.Default.remove(0);
			}

			// Prepare ParticipantsInCombat
			local participantsInCombat = [];
			while (this.Participants.m.EngagedEnemies.len() > 0 || this.Participants.m.EngagedAllies.len() > 0)
			{
				if (this.Participants.m.EngagedEnemies.len() > 0)
				{
					participantsInCombat.push(this.Participants.m.EngagedEnemies[0]);
					this.Participants.m.EngagedEnemies.remove(0);
				}

				if (this.Participants.m.EngagedAllies.len() > 0)
				{
					participantsInCombat.push(this.Participants.m.EngagedAllies[0]);
					this.Participants.m.EngagedAllies.remove(0);
				}
			}

			// Fill Combat Participants
			while (this.RegionPlan.m.Default.len() > 0 && participantsInCombat.len() > 0)
			{
				::Hardened.Tactical.Region.placeNPCsInFormation(participantsInCombat[0].getTroopDefs(), this.RegionPlan.m.Default[0]);

				this.RegionPlan.m.Default.remove(0);
				participantsInCombat.remove(0);
			}

			// Fill Other Participants
			while (this.Participants.m.Enemies.len() > 0 || this.Participants.m.Allies.len() > 0)
			{
				if (this.RegionPlan.m.Default.len() == 0) break;

				if (this.Participants.m.Enemies.len() > 0)
				{
					::Hardened.Tactical.Region.placeNPCsInFormation(this.Participants.m.Enemies[0].getTroopDefs(), this.RegionPlan.m.Default[0]);

					this.RegionPlan.m.Default.remove(0);
					this.Participants.m.Enemies.remove(0);
				}

				if (this.RegionPlan.m.Default.len() == 0) break;

				if (this.Participants.m.Allies.len() > 0)
				{
					local index = this.RegionPlan.m.Default.len() - 1;

					::Hardened.Tactical.Region.placeNPCsInFormation(this.Participants.m.Allies[0].getTroopDefs(), this.RegionPlan.m.Default[index]);

					this.RegionPlan.m.Default.remove(index);
					this.Participants.m.Allies.remove(0);
				}
			}

			// Todo: place attacker/defender
		}

		function generateRegionPlan( _combatInfo )
		{
			this.RegionPlan.clear();
			this.generatePlayerRegion(_combatInfo);
			this.RegionPlan.m.Default = this.generateDefaultRegions(_combatInfo);
			this.RegionPlan.m.Defender = this.generateDefenderRegion();
		}

		// We write our results into the member variables directly, because we generate two different regions
		function generatePlayerRegion( _combatInfo )
		{
			switch (this.EngagementType)
			{
				case ::Hardened.Tactical.EngagementType.LineBattle:
				{
					::logWarning("Hardened: generatePlayerRegion LineBattle");
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -3 });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 6, 12, { OffsetX = -3 });
					break;
				}
				case ::Hardened.Tactical.EngagementType.JoinBattle:
				{
					::logWarning("Hardened: generatePlayerRegion JoinBattle");
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -13 });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13 });
					break;
				}
				case ::Hardened.Tactical.EngagementType.AttackFortification:
				{
					local radius = ::Const.Tactical.Settings.CampRadius + _combatInfo.LocationTemplate.AdditionalRadius;
					local shiftX = _combatInfo.LocationTemplate.ShiftX;

					local offsetX = -6;
					offsetX -= radius;
					offsetX += shiftX;

					::logWarning("Hardened: generatePlayerRegion AttackFortification");
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = offsetX });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = offsetX });
					break;
				}
				case ::Hardened.Tactical.EngagementType.DefendFortification:
				{
					local radius = ::Const.Tactical.Settings.CampRadius + _combatInfo.LocationTemplate.AdditionalRadius;
					local shiftX = _combatInfo.LocationTemplate.ShiftX;

					local offsetX = -6;
					offsetX += radius;
					offsetX -= shiftX;

					::logWarning("Hardened: generatePlayerRegion DefendFortification");
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = offsetX });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = offsetX });
					break;
				}
				case ::Hardened.Tactical.EngagementType.GetAmbushed:
				{
					::logWarning("Hardened: generatePlayerRegion GetAmbushed");
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 0, 3, { IsPlayer = true });
					this.RegionPlan.m.Player.RandomPosition = true;
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 0, 3);
					this.RegionPlan.m.PersonalAlly.RandomPosition = true;
					break;
				}
				case ::Hardened.Tactical.EngagementType.DoAmbush:
				{
					::logWarning("Hardened: generatePlayerRegion DoAmbushed");
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 11, 12, { IsPlayer = true });
					this.RegionPlan.m.Player.RandomPosition = true;
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 11, 12);
					this.RegionPlan.m.PersonalAlly.RandomPosition = true;
					break;
				}
				case ::Hardened.Tactical.EngagementType.FightInfestation:
				{
					::logWarning("Hardened: generatePlayerRegion FightInfestation");
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -13 });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13 });
					break;
				}
				default:
					::logWarning("Hardened: Unsupported EngagementType: " + this.EngagementType + "! Defaulting to LineBattle");
					this.RegionPlan.m.Player = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 2, 9, { IsPlayer = true, OffsetX = -3 });
					this.RegionPlan.m.PersonalAlly = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 6, 12, { OffsetX = -3 });
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
					break;
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
					break;
				}
				case ::Hardened.Tactical.EngagementType.AttackFortification:
				{
					// Defender
					local radius = ::Const.Tactical.Settings.CampRadius + _combatInfo.LocationTemplate.AdditionalRadius;
					local shiftX = _combatInfo.LocationTemplate.ShiftX;
					local shiftY = _combatInfo.LocationTemplate.ShiftY;

					local defenderPortrait = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 6, 12, { OffsetX = radius - shiftX, OffsetY = -shiftY, Rotation = 180 });
					local defenderHexagon = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 0, radius, { OffsetX = shiftX, OffsetY = shiftY });
					defenderPortrait.intersectRegion(defenderHexagon);
					defenderPortrait.synchronizeSubRegions();
					defaultRegions.push(defenderPortrait);

					// Top
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
					// Bottom
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));
					// Far Left
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -13 }));
					break;
				}
				case ::Hardened.Tactical.EngagementType.DefendFortification:
				{
					// Defender
					local radius = ::Const.Tactical.Settings.CampRadius + _combatInfo.LocationTemplate.AdditionalRadius;
					local shiftX = _combatInfo.LocationTemplate.ShiftX;
					::logWarning("Hardened: _combatInfo.LocationTemplate.ShiftX " + _combatInfo.LocationTemplate.ShiftX);
					local shiftY = _combatInfo.LocationTemplate.ShiftY;
					local offsetX = radius - shiftX;
					local defenderPortrait = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = offsetX, OffsetY = -shiftY });
					local defenderHexagon = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 0, radius, { OffsetX = -shiftX, OffsetY = shiftY });
					defenderPortrait.intersectRegion(defenderHexagon);
					defenderPortrait.synchronizeSubRegions();
					defaultRegions.push(defenderPortrait);

					// Right (Main Attacker)
					local defenderOffsetX = -6;
					defenderOffsetX -= radius;
					defenderOffsetX += shiftX;
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = defenderOffsetX, Rotation = 180 }));
					// Top
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -10, Rotation = 90 }));
					// Bottom
					defaultRegions.push(::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Portrait, 4, 12, { OffsetX = -10, Rotation = 270 }));
					break;
				}
				case ::Hardened.Tactical.EngagementType.GetAmbushed:
				{
					local region = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 9, 10);
					region.RandomPosition = true;
					// Additional enemies and allies all spawn in the ring for simplicity reasons
					for (local n = 0; n < 10; ++n)
					{
						defaultRegions.push(region);
					}
					break;
				}
				case ::Hardened.Tactical.EngagementType.DoAmbush:
				{
					// The first 5 hostile parties will spawn in the center of the map
					local region = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 0, 5);
					region.RandomPosition = true;
					for (local n = 0; n < 5; ++n)
					{
						defaultRegions.push(region);
					}

					// The first 5 allied parties will spawn at the border together with the player
					local allyRegions = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 11, 12);
					region.RandomPosition = true;
					for (local n = 0; n < 5; ++n)
					{
						defaultRegions.push(allyRegions);
					}
					break;
				}
				case ::Hardened.Tactical.EngagementType.FightInfestation:
				{
					::logWarning("Hardened: generatePlayerRegion FightInfestation");
					local region = ::Hardened.Tactical.Region.createRegion(::Hardened.Tactical.Region.Shape.Hexagon, 0, 13, { OffsetX = 4 });
					region.RandomPosition = true;

					for (local n = 0; n < 10; ++n)
					{
						defaultRegions.push(region);
					}
					break;
				}
				default:
					::logWarning("Hardened: Unsupported EngagementType: " + this.EngagementType + "! Defaulting to LineBattle");
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
					break;
			}
			return defaultRegions;
		}

		function generateDefenderRegion()
		{
			local defenderRegions = [];
			switch (this.EngagementType)
			{
				case ::Hardened.Tactical.EngagementType.AttackFortification:
				{
					break;
				}
				case ::Hardened.Tactical.EngagementType.DefendFortification:
				{
					break;
				}
				default:
					// Todo: comment out this log
					::logWarning("Hardened: EngagementType: " + this.EngagementType + " supports no Defender Regions!");
			}
			return defenderRegions;
		}

		function onFactionCompare( _party1, _party2 )
		{
			if (_party1.getFaction() < _party2.getFaction())
			{
				return -1;
			}
			else if (_party1.getFaction() > _party2.getFaction())
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
}
