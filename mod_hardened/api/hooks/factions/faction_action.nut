::Hardened.HooksMod.hook("scripts/factions/faction_action", function(q) {
	// Public
	q.m.HD_ScoreOverwrite <- null;	// Is set to a value, then that value will be assigned as score, whenever this action rolls a score > 0
	q.m.HD_EnableCustomLocationBuilding <- false;		// If true, then this actions onUpdate and onExecute are overwritten and instead spawn locations using the information from HD_LocationTickets
	q.m.HD_AlternativeBanners <- ["banner_deserters"];	// Array of banner IDs used as alternatives to be assigned to new locations, if the nearest one is too far away or if they are the first location to be spawned
	q.m.HD_BannerAssimilationDistance <- 15;	// Spawning within this many tiles of another faction location copies their banner

	// Private
	q.m.HD_LocationTickets <- {		// Table with entry for each spawnable location script. Keys are Scriptnames and Values are Tables
		/// getHardMin(): Function that returns a number. If amount of this location script is less than that value, spawn it first
		/// HardMin: Number. If no getHardMin() is defined, use this value instead
		/// getHardMax(): Function that returns a number. If amount of this location script is more or equal to that value, stop spawning it
		/// HardMax: Number. If no getHardMax() is defined, use this value instead
		/// getRatioMin(): Function that returns a float from 0.0 to 1.0. Todo: write further docs
		/// RatioMin: Number. If no getRatioMin() is defined, use this value instead
		/// getRatioMax(): Function that returns a float from 0.0 to 1.0. Todo: write further docs
		/// RatioMax: Number. If no getRatioMax() is defined, use this value instead
		/// getWeight(): Function that returns a unsigned integer. This weight is used for the random draw of this location against alternatives
		/// Weight: Number. If no getWeight() is defined, use this value instead
	};

	q.update = @(__original) function( _isNewCampaign = false )
	{
		__original(_isNewCampaign);

		if (this.getScore() > 0 && this.m.HD_ScoreOverwrite != null)
		{
			this.m.Score = this.m.HD_ScoreOverwrite;
		}
	}

	// Overwrite, because action scaling is now done by scaling with ::Hardened.Global.getWorldDifficultyMult()
	q.getScaledDifficultyMult = @() function()
	{
		local ret = 1.0;
		ret *= ::Hardened.Global.getWorldDifficultyMult();
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		return ret;
	}

	// Overwrite, because action scaling is now done by scaling with ::Hardened.Global.getWorldDifficultyMult()
	q.getReputationToDifficultyLightMult = @() function()
	{
		local ret = 1.0;
		ret *= ::Hardened.Global.getWorldDifficultyMult();
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		return ret;
	}

// New Functions
	q.HD_getLocationsMax <- function()
	{
		return 6;
	}

	q.HD_onUpdate <- function( _faction )
	{
		if (this.HD_getLocationTypeCount(_faction).Total >= this.HD_getLocationsMax()) return;

		this.m.Score = 12;
	}

	q.HD_onExecute <- function( _faction )
	{
		local chosenLocationScript = this.HD_getLocationToSpawn(_faction);
		if (chosenLocationScript == null) return;

		local chosenTile = this.HD_findTileForLocation(chosenLocationScript);
		if (chosenTile == null) return;

		local camp = ::World.spawnLocation(chosenLocationScript, chosenTile.Coords);
		if (camp != null)
		{
			local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), this.m.HD_BannerAssimilationDistance, this.m.HD_AlternativeBanners);
			camp.onSpawned();
			camp.setBanner(banner);
			_faction.addSettlement(camp, false);
		}
	}

	q.HD_getLocationToSpawn <- function( _faction )
	{
		if (this.m.HD_LocationTickets.len() == 0) return null;

		local locationCount = this.HD_getLocationTypeCount(_faction);
		local locationsMax = this.HD_getLocationsMax();

		local priorityQueue = ::MSU.Class.WeightedContainer();
		local regularQueue = ::MSU.Class.WeightedContainer();
		foreach (script, ticket in this.m.HD_LocationTickets)
		{
			ticket.LocationTypeCount <- locationCount;
			local count = (script in locationCount) ? locationCount[script] : 0;

			local hardMax = "getHardMax" in ticket ? ticket.getHardMax() : ("HardMax" in ticket ? ticket.HardMax : null);
			if (hardMax != null && hardMax <= count) continue;

			local ratioMax = "getRatioMax" in ticket ? ticket.getRatioMax() : ("RatioMax" in ticket ? ticket.RatioMax : null);
			if (ratioMax != null && ::Math.floor(ratioMax * locationsMax) <= count) continue;

			local weight = "getWeight" in ticket ? ticket.getWeight() : ("Weight" in ticket ? ticket.Weight : 12);

			{	// Priority Queue
				local usePriorityQueue = false;

				local hardMin = "getHardMin" in ticket ? ticket.getHardMin() : ("HardMin" in ticket ? ticket.HardMin : null);
				if (hardMin != null && hardMin > count) usePriorityQueue = true;

				local ratioMin = "getRatioMin" in ticket ? ticket.getRatioMin() : ("RatioMin" in ticket ? ticket.RatioMin : null);
				if (ratioMin != null && ::Math.ceil(ratioMin * locationsMax) > count) usePriorityQueue = true;

				if (usePriorityQueue) priorityQueue.add(script, weight);
			}

			regularQueue.add(script, weight);
		}

		if (priorityQueue.len() != 0) return priorityQueue.roll();
		if (regularQueue.len() != 0) return regularQueue.roll();
		return null;
	}

	// Return a table where keys are script name hashes and values are the amount of locations existing of that type
	q.HD_getLocationTypeCount <- function( _faction )
	{
		local settlements = _faction.getSettlements();
		local ret = {
			Total = settlements.len(),
		}

		foreach (location in settlements)
		{
			local scriptName = ::IO.scriptFilenameByHash(location.ClassNameHash);
			if (scriptName in ret)
			{
				++ret[scriptName];
			}
			else
			{
				ret[scriptName] <- 1;
			}
		}

		return ret;
	}

	// Find a tile to place the location _script on top of
	// @return empty tile that the location can be placed on; or null if no tile was found
	q.HD_findTileForLocation <- function( _script )
	{
		::logInfo("Hardened: No location spawn position handling for " + _script + "! Default was used.");
		return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
			::Const.World.TerrainType.Mountains,
		], 7, 25, 1000, 7, 7);
	}

	q.HD_addLocationTicket <- function( _script, _ticketInfo )
	{
		this.m.HD_LocationTickets[_script] <- _ticketInfo;
	}

	// Re-implementation of the faction_action::getTileToSpawnLocation function
	// Changes:
	///	- Support for minX and maxX
	///	- Drop Support for nearTile
	///	- Pass Arguments as table instead of individually
	q.HD_getTileToSpawnLocation <- function( _properties )
	{
		local defaultProperties = {
			maxTries = ::Const.Factions.BuildCampTries,
			notOnTerrain = [],
			onTerrain = [],
			minDistToSettlements = 7,
			maxDistToSettlements = 1000,
			minDistToAllies = 7,
			maxDistToAllies = 1000,
			minDistToEnemies = 7,
			// nearTile = null,
			minY = 0.0,
			maxY = 1.0,
			minX = 0.0,
			maxX = 1.0,
		};

		foreach (key, value in defaultProperties)
		{
			if (key in _properties) continue;
			_properties[key] <- value;
		}

		local mapSize = ::World.getMapSize();
		local navSettings = ::World.getNavigator().createSettings();
		navSettings.ActionPointCosts = ::Const.World.TerrainTypeNavCost;
		navSettings.RoadMult = 1.0;

		local used = [];
		local tries = 0;
		while (tries++ < _properties.maxTries)
		{
			local minX = ::Math.max(3, mapSize.X * _properties.minX);
			local maxX = ::Math.min(mapSize.X - 3, mapSize.X * _properties.maxX);
			local minY = ::Math.max(3, mapSize.Y * _properties.minY);
			local maxY = ::Math.min(mapSize.Y - 4, mapSize.Y * _properties.maxY);
			local tile = ::World.getTileSquare(::Math.rand(minX, maxX), ::Math.rand(minY, maxY));
			if (used.find(tile.ID) != null) continue;

			used.push(tile.ID);
			if (tile.IsOccupied || tile.HasRoad || tile.HasRiver) continue;
			if (tile.Type == ::Const.World.TerrainType.Ocean) continue;
			if (tile.Type == ::Const.World.TerrainType.Shore) continue;
			if (::World.State.getPlayer() != null && ::World.State.getPlayer().getTile().getDistanceTo(tile) < 6) continue;

			local abort;
			{	// Check against notOnTerrain
				abort = false;
				foreach (t in _properties.notOnTerrain)
				{
					if (tile.Type == t) abort = true;
					if (abort) break;
				}
				if (abort) continue;
			}

			{	// Check against onTerrain
				if (_properties.onTerrain.len() > 0)
				{
					abort = true;
					foreach (type in _properties.onTerrain)
					{
						if (tile.Type == type) abort = false;
						if (!abort) break;
					}
					if (abort) continue;
				}
			}

			abort = false;
			foreach (nextTile in ::MSU.Tile.getNeighbors(tile))
			{
				if (nextTile.HasRoad || nextTile.Type == ::Const.World.TerrainType.Ocean)
				{
					abort = true;
					break;
				}
			}
			if (abort) continue;

			{	// Check against minDistToSettlements, maxDistToSettlements
				local closestDistance = 1000;
				foreach (settlement in ::World.EntityManager.getSettlements())
				{
					local distance = settlement.getTile().getDistanceTo(tile);
					if (distance < closestDistance)
					{
						closestDistance = distance;
					}
				}
				if (closestDistance < _properties.minDistToSettlements || closestDistance > _properties.maxDistToSettlements) continue;
			}

			{	// Check against minDistToAllies, maxDistToAllies, minDistToEnemies
				abort = false;
				local closestAllyDistance = null;
				foreach (otherLocation in ::World.EntityManager.getLocations())
				{
					local distance = tile.getDistanceTo(otherLocation.getTile());
					if (otherLocation.getFaction() == this.m.Faction.getID())
					{
						if (abort) break;
						if (distance < _properties.minDistToAllies) abort = true;
						if (closestAllyDistance == null || distance < closestAllyDistance) closestAllyDistance = distance;
					}
					else
					{
						if (distance < _properties.minDistToEnemies)
						{
							abort = true;
							break;
						}
					}
				}
				if (abort) continue;
				if (closestAllyDistance != null && closestAllyDistance > _properties.maxDistToAllies) continue;
			}

			{	// Check against nearby roads
				abort = false;
				for (local x = tile.SquareCoords.X - 3; x < tile.SquareCoords.X + 3; ++x)
				{
					for (local y = tile.SquareCoords.Y - 3; y < tile.SquareCoords.Y + 3; ++y)
					{
						if (!::World.isValidTileSquare(x, y)) continue;
						if (::World.getTileSquare(x, y).HasRoad) abort = true;
						if (abort) break;
					}
					if (abort) break;
				}
				if (abort) continue;
			}

			{	// Check against Isolation
				abort = true;
				foreach (location in ::World.EntityManager.getLocations())
				{
					if (location.isIsolated()) continue;

					local path = ::World.getNavigator().findPath(tile, location.getTile(), navSettings, 0);
					if (!path.isEmpty()) abort = false;
					if (abort) break;
				}
				if (abort) continue;
			}

			return tile;
		}

		return null;
	}
});

::Hardened.HooksMod.hookTree("scripts/factions/faction_action", function(q) {
	q.onUpdate = @(__original) function( _faction )
	{
		if (this.m.HD_EnableCustomLocationBuilding)
		{
			return this.HD_onUpdate(_faction);
		}
		else
		{
			return __original(_faction);
		}
	}

	q.onExecute = @(__original) function( _faction )
	{
		if (this.m.HD_EnableCustomLocationBuilding)
		{
			return this.HD_onExecute(_faction);
		}
		else
		{
			return __original(_faction);
		}
	}
});
