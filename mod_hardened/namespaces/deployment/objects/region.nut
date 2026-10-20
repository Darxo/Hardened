::Hardened.Deployment.Region <- class {
	Shape = null;
	Tiles = null;		// Array of SquareCoords, so that we can deal with coords out of bound
	SubRegions = null;
	RandomPosition = null;

	CreationParameters = {
		Width = null,
		Height = null,
		RadiusMin = null,
		RadiusMax = null,
	}

	// Enum for determining where a certain unit prefers to spawn
	// If all spawn positions of a type are full, the following order is employed
	// Front -> Flank -> Backline -> Center -> Ranged -> Siege -> Ranged -> Center -> Backline -> Flank -> Front
	// Flank-> Front

	FillUpOrder = null;

	constructor( _shape )
	{
		this.Shape = _shape;
		this.Tiles = [];
		this.SubRegions = {};
		foreach (key, value in ::Hardened.Deployment.FormationRole)
		{
			this.SubRegions[value] <- [];
		}
		this.RandomPosition = null;
		this.CreationParameters = {
			Width = null,
			Height = null,
			RadiusMin = null,
			RadiusMax = null,
		};
		this.FillUpOrder = [
			::Hardened.Deployment.FormationRole.Front,
			::Hardened.Deployment.FormationRole.Flank,
			::Hardened.Deployment.FormationRole.Center,
			::Hardened.Deployment.FormationRole.Backline,
			::Hardened.Deployment.FormationRole.Ranged,
			::Hardened.Deployment.FormationRole.Siege,
			::Hardened.Deployment.FormationRole.Leftover,
		];
	}

// Public
	// Must be called, before this region is transformed around
	function initSubRegions()
	{
		// Prefer raised/covered positions for the type of Ranged
		local centerTile = ::Hardened.Tactical.MapInfo.m.CenterTile;
		foreach (coordPair in this.Tiles)
		{
			if (this.Shape == ::Hardened.Deployment.RegionShape.Portrait)
			{
				switch (coordPair.X)
				{
					case centerTile.SquareCoords.X:
						this.SubRegions[::Hardened.Deployment.FormationRole.Front].push(coordPair);
						break;
					case centerTile.SquareCoords.X - 1:
						this.SubRegions[::Hardened.Deployment.FormationRole.Backline].push(coordPair);
						break;
					case centerTile.SquareCoords.X - 2:
						this.SubRegions[::Hardened.Deployment.FormationRole.Ranged].push(coordPair);
						break;
					case centerTile.SquareCoords.X - 3:
						this.SubRegions[::Hardened.Deployment.FormationRole.Siege].push(coordPair);
						break;
					default:
						this.SubRegions[::Hardened.Deployment.FormationRole.Leftover].push(coordPair);
				}
			}
			else if (this.Shape == ::Hardened.Deployment.RegionShape.Landscape)
			{
				switch (coordPair.Y)
				{
					case centerTile.SquareCoords.Y:
						this.SubRegions[::Hardened.Deployment.FormationRole.Front].push(coordPair);
						break;
					case centerTile.SquareCoords.Y + 1:
						this.SubRegions[::Hardened.Deployment.FormationRole.Backline].push(coordPair);
						break;
					case centerTile.SquareCoords.Y + 2:
						this.SubRegions[::Hardened.Deployment.FormationRole.Ranged].push(coordPair);
						break;
					case centerTile.SquareCoords.Y + 3:
						this.SubRegions[::Hardened.Deployment.FormationRole.Siege].push(coordPair);
						break;
					default:
						this.SubRegions[::Hardened.Deployment.FormationRole.Leftover].push(coordPair);
				}
			}
			else if (this.Shape == ::Hardened.Deployment.RegionShape.Hexagon)
			{
				if (!::Tactical.isValidTileSquare(coordPair.X, coordPair.Y))
				{
					this.SubRegions[::Hardened.Deployment.FormationRole.Leftover].push(coordPair);
					continue;
				}

				local tile = ::Tactical.getTileSquare(coordPair.X, coordPair.Y);
				local distanceToCenter = tile.getDistanceTo(centerTile);
				distanceToCenter = ::Math.clamp(distanceToCenter, this.CreationParameters.RadiusMin, this.CreationParameters.RadiusMax);
				switch (distanceToCenter)
				{
					case this.CreationParameters.RadiusMax:
						this.SubRegions[::Hardened.Deployment.FormationRole.Front].push(coordPair);
						break;
					case this.CreationParameters.RadiusMax - 1:
						this.SubRegions[::Hardened.Deployment.FormationRole.Backline].push(coordPair);
						break;
					case this.CreationParameters.RadiusMax - 2:
						this.SubRegions[::Hardened.Deployment.FormationRole.Ranged].push(coordPair);
						break;
					case this.CreationParameters.RadiusMax - 3:
						this.SubRegions[::Hardened.Deployment.FormationRole.Siege].push(coordPair);
						break;
					default:
						this.SubRegions[::Hardened.Deployment.FormationRole.Leftover].push(coordPair);
				}
			}
		}

		foreach (key, value in this.SubRegions)
		{
			this.sortByDistanceToCenter(value, centerTile);
		}

		switch (this.Shape)
		{
			case ::Hardened.Deployment.RegionShape.Portrait:
			case ::Hardened.Deployment.RegionShape.Landscape:
			{
				local front = this.SubRegions[::Hardened.Deployment.FormationRole.Front];
				if (front.len() >= 10)
				{
					this.SubRegions[::Hardened.Deployment.FormationRole.Flank].push(front.remove(front.len() - 1));
					this.SubRegions[::Hardened.Deployment.FormationRole.Flank].push(front.remove(front.len() - 1));
					this.SubRegions[::Hardened.Deployment.FormationRole.Flank].push(front.remove(front.len() - 1));
					this.SubRegions[::Hardened.Deployment.FormationRole.Flank].push(front.remove(front.len() - 1));
				}

				local backline = this.SubRegions[::Hardened.Deployment.FormationRole.Backline];
				if (backline.len() >= 10)
				{
					this.SubRegions[::Hardened.Deployment.FormationRole.Flank].push(backline.remove(backline.len() - 1));
					this.SubRegions[::Hardened.Deployment.FormationRole.Flank].push(backline.remove(backline.len() - 1));
					this.SubRegions[::Hardened.Deployment.FormationRole.Flank].push(backline.remove(backline.len() - 1));
					this.SubRegions[::Hardened.Deployment.FormationRole.Flank].push(backline.remove(backline.len() - 1));

					this.SubRegions[::Hardened.Deployment.FormationRole.Center].push(backline.remove(0));
					this.SubRegions[::Hardened.Deployment.FormationRole.Center].push(backline.remove(0));
				}

				break;
			}
			default:
		}
	}

	function transformRegion( _offsetX, _offsetY, _rotation = 0 )
	{
		foreach (tile in this.Tiles)
		{
			tile.X += _offsetX;
			tile.Y += _offsetY;
		}

		while (::Math.abs(_rotation) >= 60)
		{
			this.rotateAllTiles(_rotation > 0);
			_rotation += (_rotation > 0) ? -60 : 60;
		}
	}

	function translateVanillaRow( _row )
	{
		if (_row == -1) _row = ::Math.rand(1, 3);	// Same as Vanilla

		switch (_row)
		{
			case 0:
				return ::Hardened.Deployment.FormationRole.Front;
			case 1:
				return ::Hardened.Deployment.FormationRole.Backline;
			case 2:
				return ::Hardened.Deployment.FormationRole.Ranged;
			case 3:
				return ::Hardened.Deployment.FormationRole.Siege;
			case -2:
				return ::Hardened.Deployment.FormationRole.Random;
			default:
				return ::Hardened.Deployment.FormationRole.Front;
		}
	}

	function getAllTiles( _subRegionType = null )
	{
		local squarecoordsArray = [];
		foreach (key, value in this.SubRegions)
		{
			if (key != _subRegionType) continue;
			squarecoordsArray.extend(value);
		}

		if (squarecoordsArray.len() == 0) squarecoordsArray = this.Tiles;	// temp solution to allow player characters spawning

		local allTiles = [];

		foreach (coords in squarecoordsArray)
		{
			if (!::Tactical.isValidTileSquare(coords.X, coords.Y)) continue;

			allTiles.push(::Tactical.getTileSquare(coords.X, coords.Y));
		}

		// Remove all tiles that count as impassable. Vanilla does not place such tiles, but in Hardened we define Void Tiles as such
		for (local index = allTiles.len() - 1; index >= 0; --index)
		{
			if (allTiles[index].Type == ::Const.Tactical.TerrainType.Impassable)
			{
				allTiles.remove(index);
			}
		}

		return allTiles;
	}

	function placeTroop( _troopDef, _strict )
	{
		local validTile = this.findEmptyTile(_troopDef, _strict);
		if (validTile == null)
		{
			return false;
		}

		local entity = ::Tactical.spawnEntity(_troopDef.Script, validTile.Coords);
		::Tactical.Entities.setupEntity(entity, _troopDef);
		return true;
	}

// Private
	function rotateAllTiles( _clockwise )
	{
		local ccCenterTile = ::Hardened.Deployment.CubeCoordinates.fromTacticalTile(::Hardened.Tactical.MapInfo.m.CenterTile);
		foreach (coordPair in this.Tiles)
		{
			local ccTile = ::Hardened.Deployment.CubeCoordinates.fromSquareCoords(coordPair);
			if (_clockwise)
			{
				ccTile.rotateClockWise(ccCenterTile);
			}
			else
			{
				ccTile.rotateCounterClockWise(ccCenterTile);
			}
			local rotatedCoords = ::Hardened.Deployment.CubeCoordinates.toSquareCoords(ccTile);
			coordPair.X = rotatedCoords.X;
			coordPair.Y = rotatedCoords.Y;
		}
	}

	// Remove all objects from this region and a border around them of _borderSize distance
	function clearArea( _borderSize = 0, _onlyVisionBlocking = false )
	{
		local affectedTiles = ::Hardened.util.expandTileArray(this.getAllTiles(), _borderSize);

		foreach (tile in affectedTiles)
		{
			if (tile.IsEmpty) continue;
			if (_onlyVisionBlocking && !tile.getEntity().isBlockingSight()) continue;

			tile.removeObject();
		}
	}

	function downsizeArea(  _borderSize = 0 )
	{
		local affectedTiles = ::Hardened.util.expandTileArray(this.getAllTiles(), _borderSize);

		// Remove all tower- or wall-like structures in the region
		foreach (tile in affectedTiles)
		{
			if (tile.Level > 3)
			{
				tile.Level = 1;
			}
		}

		// Adjust levels to hopefully fix isolations
		foreach (tile in affectedTiles)
		{
			if (!::Tactical.Entities.isTileIsolated(tile)) continue;

			local avg = 0;
			local neighborAmount = 0;
			foreach (nextTile in ::MSU.Tile.getNeighbors(tile))
			{
				if (nextTile.Level > 3) continue;

				++neighborAmount;
				avg += nextTile.Level;
			}
			tile.Level = avg / neighborAmount;
		}
	}

	/// Sort all tile in _tileArray, so that the tile which is the closest to a center tile comes first
	/// If no _centerTile is passed, the center of all passed tiles as a tile is used
	function sortByDistanceToCenter( _tileArray, _centerTile = null )
	{
		if (_tileArray.len() == 0) return;

		if (_centerTile == null)
		{
			local center = { X = 0, Y = 0 };
			// First we calculate the average center tile of all tiles of this Region

			foreach (tile in _tileArray)
			{
				center.X += tile.X;
				center.Y += tile.Y;
			}
			center.X /= ::Math.round(_tileArray.len());
			center.Y /= ::Math.round(_tileArray.len());
			_centerTile = ::Tactical.getTileSquare(center.X, center.Y);
		}

		local sort = function( _a, _b )
		{
			if (!::Tactical.isValidTileSquare(_a.X, _a.Y)) return 0;
			if (!::Tactical.isValidTileSquare(_b.X, _b.Y)) return 0;
			local tileA = ::Tactical.getTileSquare(_a.X, _a.Y);
			local tileB = ::Tactical.getTileSquare(_b.X, _b.Y);
			if (tileA.getDistanceTo(_centerTile) < tileB.getDistanceTo(_centerTile))
			{
				return -1;
			}
			else if (tileA.getDistanceTo(_centerTile) > tileB.getDistanceTo(_centerTile))
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}

		_tileArray.sort(sort);
		return _tileArray;
	}

	/// Try to find a valid tile to fit the passed _troopDef onto
	/// @param _strict if true, then the troop can only be placed in its designated formationRole, otherwise it will fill up any empty tile
	/// @return empty tile from our region, if one could be found, or null if no valid tile was found
	function findEmptyTile( _troopDef = null, _strict = true )
	{
		if (_troopDef == null || this.RandomPosition)
		{
			local validTiles = [];
			foreach (tile in this.getAllTiles())
			{
				if (!tile.IsEmpty) continue;
				validTiles.push(tile);
			}
			return validTiles.len() == 0 ? null : ::MSU.Array.rand(validTiles);
		}

		local formationRole =  this.translateVanillaRow(_troopDef.Row);
		if ("HD_FormationRole" in _troopDef)
		{
			formationRole = _troopDef.HD_FormationRole;
		}

		foreach (tile in this.getAllTiles(formationRole))
		{
			if (!tile.IsEmpty) continue;

			return tile;
		}

		if (_strict) return null;

		foreach (role in this.FillUpOrder)
		{
			foreach (tile in this.getAllTiles(role))
			{
				if (!tile.IsEmpty) continue;

				return tile;
			}
		}

		return null;
	}

	/// Removes all tiles that are also contained in _otherRegion
	function excludeRegion( _otherRegion )
	{
		for (local index = this.Tiles.len() - 1; index >= 0; --index)
		{
			local tile = this.Tiles[index];
			foreach (otherTile in _otherRegion.Tiles)
			{
				if (!::MSU.deepEquals(tile, otherTile)) continue;

				this.Tiles.remove(index);
				break;
			}
		}
	}

	/// Adds all tiles from _otherRegion that are not already contained in this region
	function includeRegion( _otherRegion )
	{
		foreach (otherTile in _otherRegion.Tiles)
		{
			foreach (tile in this.Tiles)
			{
				if (::MSU.deepEquals(tile, otherTile)) continue;

				// Todo: check for duplicates
				this.Tiles.push(otherTile);
				break;
			}
		}
	}

	/// Removes all tiles that are not also contained in _otherRegion
	function intersectRegion( _otherRegion )
	{
		local newTiles = [];
		foreach (tile in this.Tiles)
		{
			foreach (otherTile in _otherRegion.Tiles)
			{
				if (!::MSU.deepEquals(tile, otherTile)) continue;

				newTiles.push(tile);
				break;
			}
		}
		this.Tiles = newTiles;
	}

	// Remove all tiles from subregions, that are no longer present in this.Tiles. This can happen during intersect and exclude calls
	function synchronizeSubRegions()
	{
		foreach (key, subregion in this.SubRegions)
		{
			for (local index = subregion.len() - 1; index >= 0; --index)
			{
				local subregionTile = subregion[index];
				local stillPresent = false;
				foreach (tile in this.Tiles)
				{
					if (::MSU.deepEquals(tile, subregionTile))
					{
						stillPresent = true;
						break;
					}
				}
				if (!stillPresent)
				{
					subregion.remove(index);
				}
			}
		}
	}
}
