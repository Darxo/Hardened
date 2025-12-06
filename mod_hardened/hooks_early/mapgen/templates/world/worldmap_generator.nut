::Hardened.HooksMod.hook("scripts/mapgen/templates/world/worldmap_generator", function(q) {
	q.m.HD_HalfSizePct <- 0.6;	// How large is the chosen right/left half of the map on its X axis?
	q.m.HD_MapBorderSize <- 5;	// Settlements won't spawn this many tiles from the map border

	// Overwrite, because we make the settlement algorithm cleaner, more moddoable and more consistent
	// Changes:
	//	- We start by generating an array of valid tiles, excluding the map border, as defined by HD_MapBorderSize and excluding all Ocean and Shore tiles
	//	- We no longer limit the tries to 3000. Instead for each Settlement to place, we randomize the array with valid tiles and then iterate over it from start to finish
	//	- We prevent the first settlement to be placed to be accidentally appear on a completely isolated island
	//	- If a chosen tile is not at the coast and only 1 tile away from the coast, we instead continue with that adjacent tile
	q.buildSettlements = @() function( _rect )
	{
		logInfo("Hardened: Building settlements...");

		// We randomly decide, whether the settlements should be spawned on the right or left side of the map
		local isLeft = Math.rand(0, 1);

		local validTiles = [];
		foreach (column in this.m.WorldTiles)
		{
			foreach (tile in column)
			{
				// Currently no settlement is ever allowed to spawn on these tiles, so we filter them out right from the beginning
				if (tile.Type == ::Const.World.TerrainType.Shore) continue;
				if (tile.Type == ::Const.World.TerrainType.Ocean) continue;

				// Settlements may never spawn near the map border
				if (tile.SquareCoords.X <= this.m.HD_MapBorderSize) continue;
				if (tile.SquareCoords.X >= _rect.W - this.m.HD_MapBorderSize) continue;
				if (tile.SquareCoords.Y <= this.m.HD_MapBorderSize) continue;
				if (tile.SquareCoords.Y >= _rect.H - this.m.HD_MapBorderSize) continue;

				validTiles.push(tile);
			}
		}

		local settlementTiles = [];
		foreach (list in ::Const.World.Settlements.Master)
		{
			local ignoreSide = "IgnoreSide" in list && list.IgnoreSide;

			// Some settlements want multiple of them placed
			for (local num = list.Amount; num > 0; --num)
			{
				// We randomize validTiles, so that we have a fresh random list of tiles to iterate over for trying to place the settlement
				// This prevents accidentally checking the same tile multiples times
				::MSU.Array.shuffle(validTiles);

				for (local index = validTiles.len() -1; index >= 0; --index)	// We go in reverse, so that we can delete validTiles entries without invalidating the loop
				{
					local tile = validTiles[index];

					// Make sure that settlements, which don't ignore the side, are only allowed to spawn on the chosen half
					if (!ignoreSide)
					{
						if (isLeft)
						{
							if (tile.SquareCoords.X > _rect.W * this.m.HD_HalfSizePct) continue;
						}
						else
						{
							if (tile.SquareCoords.X < _rect.W * (1.0 - this.m.HD_HalfSizePct)) continue;
						}
					}

					// sufficient land?
					local terrain = this.getTerrainInRegion(tile);
					if (terrain.Adjacent[::Const.World.TerrainType.Ocean] >= 3 || terrain.Adjacent[::Const.World.TerrainType.Shore] >= 3)
					{
						validTiles.remove(index);	// We found a tile that will never be valid, so we remove it for performance reasons so its not considered for future iterations
						continue;
					}

					// Let's try to find a neighboring tile then, which might have water (new, compared to Vanilla)
					if (terrain.Adjacent[::Const.World.TerrainType.Ocean] == 0 && terrain.Adjacent[::Const.World.TerrainType.Shore] == 0)
					{
						if (terrain.Region[::Const.World.TerrainType.Ocean] > 0 || terrain.Region[::Const.World.TerrainType.Shore] > 0)	// quick check, whether our nearby tiles contain water at all
						{
							foreach (neighbor in ::MSU.Tile.getNeighbors(tile))
							{
								local neighborTerrain = this.getTerrainInRegion(neighbor);
								if (neighborTerrain.Adjacent[::Const.World.TerrainType.Ocean] == 0 && neighborTerrain.Adjacent[::Const.World.TerrainType.Shore] == 0) continue;
								if (neighborTerrain.Adjacent[::Const.World.TerrainType.Ocean] >= 3) continue;
								if (neighborTerrain.Adjacent[::Const.World.TerrainType.Shore] >= 3) continue;

								// We nudge the found tile once towards its neighbors so that it touches water now
								// This improves the overall chances of Coastal settlements to be placed
								// and also prevents IsFlexible settlements from spawning exactly 1 tile away from water
								tile = neighbor;

								// We found an invalid tile but that one will be removed later on anyways, so we must not remove it here
								// However, the swapped tile will not be removed from validTiles; we don't know its index. So it might be picked in a future run
								// But then it will be filtered out by the distance to others check anyways so it's ok
								break;
							}
						}
					}

					// distance to other settlements?
					local next = false;
					foreach (settlement in settlementTiles)
					{
						if (tile.getDistanceTo(settlement) < 12 + list.AdditionalSpace)	// In Hardened we always guarantee AdditionalSpace to be part of a list entry
						{
							next = true;
							break;
						}
					}
					if (next) continue;

					// find fitting candidate
					local candidates = [];
					foreach (settlementType in list.List)
					{
						if (settlementType.isSuitable(terrain)) candidates.push(settlementType);
					}
					if (candidates.len() == 0) continue;
					local settlementType = ::MSU.Array.rand(candidates);

					// if ocean near and not coastal, try again
					if (!("IsCoastal" in settlementType) && !("IsFlexible" in settlementType))
					{
						if (terrain.Region[::Const.World.TerrainType.Ocean] >= 3) continue;
						if (terrain.Region[::Const.World.TerrainType.Shore] >= 3) continue;
					}

					// No settlement is allowed to be isolated
					if (this.HD_isIsolated(tile, settlementTiles, _rect, "IsCoastal" in settlementType)) continue;

					tile.clear();
					::World.spawnLocation(settlementType.Script, tile.Coords);
					settlementTiles.push(tile);
					validTiles.remove(index);	// This is to slightly improve performance of future generations
					break;
				}
			}
		}

		logInfo("Hardened: Created " + settlementTiles.len() + " settlements.");
	}

// New Functions
	// Calculates, whether a settlement placed on _tile would be isolated (no connection to any other settlement from _settlementTiles)
	// This takes into consideration, whether the placed settlement _isCoastal, which would allow connections via sea
	// If there are no other settlements yet, we use the center of the map, as per _rect, as a dummy settlement
	q.HD_isIsolated <- function( _tile, _settlementTiles, _rect, _isCoastal)
	{
		local navSettings = ::World.getNavigator().createSettings();
		if (_isCoastal)
		{
			navSettings.ActionPointCosts = ::Const.World.TerrainTypeNavCost;	// Anything is allowed
		}
		else
		{
			navSettings.ActionPointCosts = ::Const.World.TerrainTypeNavCost_Flat;	// Only on land
		}

		if (_settlementTiles.len() == 0)	// There are not yet other settlements to check isolation against
		{
			// We assume that the center tile of the map is always on the mainland, where the majority of settlements should also appear
			// Therefor the first settlement to place, must be placed on main land
			// This approach fixes a potential vanilla issue, where a non-coastal town could spawn on an isolated island
			local dummyCenterTile = this.m.WorldTiles[_rect.W / 2][_rect.H / 2];
			local path = ::World.getNavigator().findPath(_tile, dummyCenterTile, navSettings, 0);
			if (!path.isEmpty()) return false;
		}
		else
		{
			foreach (settlement in _settlementTiles)
			{
				local path = ::World.getNavigator().findPath(_tile, settlement, navSettings, 0);
				if (!path.isEmpty()) return false;
			}
		}

		return true;
	}
});
