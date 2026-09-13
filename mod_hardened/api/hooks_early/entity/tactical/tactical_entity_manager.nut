::Hardened.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	// Overwrite, because we split up this large vanilla function to make it more moddable
	q.spawn = @() { function spawn( _properties )
	{
		// Seeding
		if (::World.State.getCombatSeed() != 0)
		{
			::Math.seedRandom(::World.State.getCombatSeed());
		}

		::Time.setRound(0);

		foreach (faction in _properties.TemporaryEnemies)
		{
			if (faction > 2)
			{
				::World.FactionManager.getFaction(faction).setIsTemporaryEnemy(true);
			}
		}

		// In Vanilla this is called after player characters are gathered. We instead give the opportunity to influence that process
		if (_properties.BeforeDeploymentCallback != null)
		{
			_properties.BeforeDeploymentCallback();
		}

		this.HD_calculatePlayerDeploymentType(_properties);
		local playerCharacters = this.HD_preparePlayerCharacters(_properties);
		this.HD_deployPlayerCharacters(_properties, playerCharacters);

		local aiParticipants = this.HD_prepareAIParticipants(_properties);

		this.HD_calculateDeploymentTypes(_properties, aiParticipants);
		this.HD_deployAIParticipants(_properties, aiParticipants);

		// Callback after all AI participants have been deployed
		if (_properties.EnemyDeploymentCallback != null)
		{
			_properties.EnemyDeploymentCallback();
		}

		// This vanilla variable might have had some use at some point. But it's currently unused
		this.m.IsLineVSLine = _properties.PlayerDeploymentType == ::Const.Tactical.DeploymentType.Line && _properties.EnemyDeploymentType == ::Const.Tactical.DeploymentType.Line;

		if (!::Tactical.State.isScenarioMode() && !_properties.IsPlayerInitiated && !_properties.InCombatAlready)
		{
			foreach( i, s in this.m.Strategies )
			{
				if (!::World.FactionManager.isAllied(::Const.Faction.Player, i))
				{
					s.setIsAttackingOnWorldmap(true);
				}
			}
		}

		if (_properties.AfterDeploymentCallback != null)
		{
			_properties.AfterDeploymentCallback();
		}

		if (_properties.IsAutoAssigningBases)
		{
			this.assignBases();
		}
		this.makeEnemiesKnownToAI(_properties.InCombatAlready);

		if (::World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			local roster = ::World.getPlayerRoster().getAll();
			local slaves = 0;
			local nonSlaves = 0;

			foreach( bro in roster )
			{
				if (!bro.isPlacedOnMap())
				{
					continue;
				}

				if (bro.getBackground().getID() == "background.slave")
				{
					slaves = ++slaves;
				}
				else
				{
					nonSlaves = ++nonSlaves;
				}
			}

			if (slaves <= nonSlaves)
			{
				foreach( bro in roster )
				{
					if (!bro.isPlacedOnMap())
					{
						continue;
					}

					if (bro.getBackground().getID() != "background.slave")
					{
						bro.worsenMood(::Const.MoodChange.TooFewSlavesInBattle, "Too few indebted in battle");
					}
				}
			}
		}

		foreach( player in this.m.Instances[::Const.Faction.Player] )
		{
			player.onCombatStart();
		}

		::Math.seedRandom(::Time.getRealTime());
	}}.spawn;

	/// @return array of player characters (+ guests)
	q.HD_preparePlayerCharacters <- function( _properties )
	{
		::World.Assets.updateFormation();

		local ret = [];
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

			ret.push(brother);
			if (ret.len() >= ::World.Assets.getBrothersMaxInCombat()) break;
		}

		if (::World.State.isUsingGuests() && ::World.getGuestRoster().getSize() != 0)
		{
			ret.extend(::World.getGuestRoster().getAll());
		}

		return ret;
	}

	q.HD_calculatePlayerDeploymentType <- function( _properties )
	{
		// Player Deployment Type
		if (_properties.PlayerDeploymentType == ::Const.Tactical.DeploymentType.Auto)
		{
			if (::World.State.getEscortedEntity() != null && !::World.State.getEscortedEntity().isNull())
			{
				_properties.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Line;
			}
			else if (_properties.LocationTemplate != null && _properties.LocationTemplate.Fortification != ::Const.Tactical.FortificationType.None && !_properties.LocationTemplate.ForceLineBattle)
			{
				_properties.PlayerDeploymentType = ::Const.Tactical.DeploymentType.LineBack;
			}
			else if ((::Const.World.TerrainTypeLineBattle[_properties.Tile.Type] || _properties.IsAttackingLocation || _properties.IsPlayerInitiated) && !_properties.InCombatAlready)
			{
				_properties.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Line;
			}
			else if (!_properties.InCombatAlready)
			{
				_properties.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Center;
			}
			else
			{
				_properties.PlayerDeploymentType = ::Const.Tactical.DeploymentType.LineBack;
			}
		}
	}

	/// @return array with tables describing all non-player participating factions
	q.HD_prepareAIParticipants <- function( _properties )
	{
		// Non-Player Participant Merging
		_properties.Entities.sort(this.onFactionCompare);

		local participatingAIFactions = [];
		foreach (party in _properties.Entities)
		{
			// Is this is a party from a faction we haven't had yet, we create a new entry. Otherwise we merge them
			if (participatingAIFactions.len() == 0 || participatingAIFactions[participatingAIFactions.len() - 1].Faction != party.Faction)
			{
				local f = {
					Faction = party.Faction,
					IsAlliedWithPlayer = ::World.FactionManager.isAlliedWithPlayer(party.Faction),
					IsOwningLocation = false,
					DeploymentType = _properties.EnemyDeploymentType,
					Entities = [],	//
				};
				participatingAIFactions.push(f);

				if (_properties.LocationTemplate != null && ::World.FactionManager.isAllied(f.Faction, _properties.LocationTemplate.OwnedByFaction))
				{
					f.IsOwningLocation = true;
				}
			}

			participatingAIFactions[participatingAIFactions.len() - 1].Entities.push(party);
		}

		participatingAIFactions.sort(function ( _a, _b )
		{
			if (_a.IsOwningLocation && !_b.IsOwningLocation)
			{
				return -1;
			}
			else if (!_a.IsOwningLocation && _b.IsOwningLocation)
			{
				return 1;
			}

			return 0;
		});

		return participatingAIFactions;
	}

	q.HD_calculateDeploymentTypes <- function( _properties, _aiParticipants )
	{
		// Non-Player Deployment Types
		foreach (participant in _aiParticipants)
		{
			if (participant.DeploymentType != ::Const.Tactical.DeploymentType.Auto) continue;

			if (::World.State.getEscortedEntity() != null && !::World.State.getEscortedEntity().isNull())
			{
				participant.DeploymentType = ::Const.Tactical.DeploymentType.Line;
			}
			else if (participant.IsAlliedWithPlayer && !_properties.InCombatAlready)
			{
				participant.DeploymentType = _properties.PlayerDeploymentType;
			}
			else if (_properties.LocationTemplate != null && _properties.LocationTemplate.Fortification != ::Const.Tactical.FortificationType.None && !::World.FactionManager.isAllied(participant.Faction, _properties.LocationTemplate.OwnedByFaction) && !_properties.LocationTemplate.ForceLineBattle)
			{
				participant.DeploymentType = ::Const.Tactical.DeploymentType.LineBack;
			}
			else if (_properties.LocationTemplate != null && _properties.LocationTemplate.Fortification != ::Const.Tactical.FortificationType.None && ::World.FactionManager.isAllied(participant.Faction, _properties.LocationTemplate.OwnedByFaction) && !_properties.LocationTemplate.ForceLineBattle)
			{
				participant.DeploymentType = ::Const.Tactical.DeploymentType.Camp;
			}
			else if (_properties.LocationTemplate != null && (_properties.LocationTemplate.Fortification == ::Const.Tactical.FortificationType.None || _properties.LocationTemplate.ForceLineBattle))
			{
				participant.DeploymentType = ::Const.Tactical.DeploymentType.Line;
			}
			else if (::Const.World.TerrainTypeLineBattle[_properties.Tile.Type] || _properties.IsAttackingLocation || _properties.IsPlayerInitiated || _properties.InCombatAlready)
			{
				participant.DeploymentType = ::Const.Tactical.DeploymentType.Line;
			}
			else
			{
				participant.DeploymentType = ::Const.Tactical.DeploymentType.Circle;
			}
		}
	}

	q.HD_deployPlayerCharacters <- function( _properties, _playerCharacters )
	{
		local shiftX = _properties.LocationTemplate != null ? _properties.LocationTemplate.ShiftX : 0;
		local shiftY = _properties.LocationTemplate != null ? _properties.LocationTemplate.ShiftY : 0;
		switch(_properties.PlayerDeploymentType)
		{
		case ::Const.Tactical.DeploymentType.Line:
			this.placePlayersInFormation(_playerCharacters);
			break;

		case ::Const.Tactical.DeploymentType.LineBack:
			if (_properties.InCombatAlready)
			{
				this.placePlayersInFormation(_playerCharacters, -10);
			}
			else
			{
				this.placePlayersInFormation(_playerCharacters, -10 + shiftX);
			}

			break;

		case ::Const.Tactical.DeploymentType.LineCenter:
			this.placePlayersInFormation(_playerCharacters, 3 + shiftX);
			break;

		case ::Const.Tactical.DeploymentType.LineForward:
			this.placePlayersInFormation(_playerCharacters, 8 + shiftX);
			break;

		case ::Const.Tactical.DeploymentType.Arena:
			this.placePlayersInFormation(_playerCharacters, -4, -3);
			break;

		case ::Const.Tactical.DeploymentType.Center:
			this.placePlayersAtCenter(_playerCharacters);
			break;

		case ::Const.Tactical.DeploymentType.Edge:
			this.placePlayersAtBorder(_playerCharacters);
			break;

		case ::Const.Tactical.DeploymentType.Random:
		case ::Const.Tactical.DeploymentType.Circle:
			this.placePlayersInCircle(_playerCharacters);
			break;

		case ::Const.Tactical.DeploymentType.Custom:
			if (_properties.PlayerDeploymentCallback != null)
			{
				_properties.PlayerDeploymentCallback();
			}

			break;
		}
	}

	q.HD_deployAIParticipants <- function( _properties, _aiParticipants )
	{
		local occupiedRegions = 0;

		local hasCampDeployment = false;
		if (_properties.PlayerDeploymentType != ::Const.Tactical.DeploymentType.Camp)	// New condition to support Camp deployment type for player. Otherwise, enemies will spawn top first, instead of right
		{
			foreach (ai in _aiParticipants)
			{
				if (ai.DeploymentType == ::Const.Tactical.DeploymentType.Camp)
				{
					hasCampDeployment = true;
					break;
				}
			}
		}

		if (hasCampDeployment || ::World.State.getEscortedEntity() == null && _properties.InCombatAlready && _aiParticipants.len() <= 2)
		{
			occupiedRegions++;
		}
		local lastFaction = 99;

		foreach (i, participant in _aiParticipants)
		{
			if ((!participant.IsAlliedWithPlayer || ::World.State.getEscortedEntity() == null && _properties.InCombatAlready) && participant.DeploymentType != ::Const.Tactical.DeploymentType.Camp && (lastFaction == 99 || !::World.FactionManager.isAllied(lastFaction, participant.Faction)))
			{
				++occupiedRegions;
			}

			if (occupiedRegions > 3) break;

			lastFaction = participant.Faction;

			local regionNumber = participant.IsAlliedWithPlayer && (!_properties.InCombatAlready || ::World.State.getEscortedEntity() != null) ? 0 : occupiedRegions;
			this.HD_deployAIParticipant(_properties, participant, regionNumber);
		}


	}

	q.HD_deployAIParticipant <- function( _properties, _participant, _regionNumber )
	{
		local shiftX = _properties.LocationTemplate != null ? _properties.LocationTemplate.ShiftX : 0;
		local shiftY = _properties.LocationTemplate != null ? _properties.LocationTemplate.ShiftY : 0;

		switch(_participant.DeploymentType)
		{
			case ::Const.Tactical.DeploymentType.Line:
				if (_properties.InCombatAlready)
				{
					if (_regionNumber == 1)
					{
						this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, -5, 0);
					}
					else
					{
						this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, 0, 7);
					}
				}
				else
				{
					this.spawnEntitiesInFormation(_participant.Entities, _regionNumber);
				}

				break;

			case ::Const.Tactical.DeploymentType.Camp:
				this.spawnEntitiesAtCamp(_participant.Entities, shiftX, shiftY);
				break;

			case ::Const.Tactical.DeploymentType.LineBack:
				if (_participant.IsAlliedWithPlayer && _properties.PlayerDeploymentType == ::Const.Tactical.DeploymentType.LineForward)
				{
					this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, 8 + shiftX);
				}
				else if (_participant.IsAlliedWithPlayer && _properties.PlayerDeploymentType == ::Const.Tactical.DeploymentType.LineCenter)
				{
					this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, 3 + shiftX);
				}
				else if (!_participant.IsAlliedWithPlayer && _properties.PlayerDeploymentType == ::Const.Tactical.DeploymentType.LineForward)
				{
					this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, -10 - shiftX);
				}
				else
				{
					this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, -10 + shiftX);
				}

				break;

			case ::Const.Tactical.DeploymentType.LineCenter:
				if (_participant.IsAlliedWithPlayer && _properties.PlayerDeploymentType == ::Const.Tactical.DeploymentType.LineForward)
				{
					this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, 8 + shiftX);
				}
				else if (!_participant.IsAlliedWithPlayer && _properties.PlayerDeploymentType == ::Const.Tactical.DeploymentType.LineForward)
				{
					this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, 3 - shiftX);
				}
				else
				{
					this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, 3 + shiftX);
				}

				break;

			case ::Const.Tactical.DeploymentType.Arena:
				this.spawnEntitiesInFormation(_participant.Entities, _regionNumber, 3, -3);
				break;

			case ::Const.Tactical.DeploymentType.Center:
				this.spawnEntitiesAtCenter(_participant.Entities);
				break;

			case ::Const.Tactical.DeploymentType.Random:
				this.spawnEntitiesRandomly(_participant.Entities);
				break;

			case ::Const.Tactical.DeploymentType.Circle:
				this.spawnEntitiesInCircle(_participant.Entities);
				break;
		}
	}
});
