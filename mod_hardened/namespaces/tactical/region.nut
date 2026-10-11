// Defines an area of tiles that are meant to be the target of spawning

::Hardened.Tactical.Region <- {
	Shape = {
		Portrait = "HD_Portrait",	// Classic Vanilla upright rectangle, whose right-center tile is the center tile of the map
		Landscape = "HD_Landscape",	// Flat rectangle, whose bottom-center tile is the center tile of the map
		Hexagon = "HD_Hexagon",	// Hexagonshape with an optional hole in the middle
	}

	// Public
		/// @param _shape size in tiles on the x axis of the generated region
		/// @param _width size in tiles on the x axis of the generated region. When generating a Hexagon, this will be its _radiusMin
		/// @param _height size in tiles on the y axis of the generated region. When generating a Hexagon, this will be its _radiusMax
		/// @param _options table of various options
		function createRegion( _shape, _width, _height, _options = {} )
		{
			local options = {
				IsPlayer = false,	// Is this region specifically for the player, where other positioning rules exist?
				OffsetX = 0,		// tile offset of this region on the X axis after generation and before rotation
				OffsetY = 0,		// tile offset of this region on the Y axis after generation and before rotation
				Rotation = 0,		// rotate the region for 60° clockwise (positive) or counter-clockwise (negative) for every 1 value
			};
			::MSU.Table.merge(options, _options);		// overwrite defaults with passed options

			if (_shape == this.Shape.Portrait && ::Math.abs(options.Rotation) % 60 == 30)
			{
				_shape = this.Shape.Landscape;
				options.Rotation -= 90;
				local oldY = options.OffsetY;
				options.OffsetY = -options.OffsetX;		// Needs inversed
				options.OffsetX = oldY;					// Probably does not need inversion
				/*local oldWidth = _width;
				_width = _height;
				_height = oldWidth;*/
			}

			local region = null;
			switch (_shape)
			{
				case this.Shape.Portrait:
				{
					region = this.createRegionPortrait(_width, _height);
					break;
				}
				case this.Shape.Landscape:
				{
					region = this.createRegionLandscape(_height, _width);
					break;
				}
				case this.Shape.Hexagon:	// Hexagon shape that is facing outwards
				{
					region = this.createRegionHexagonal(_height, _width);
					break;
				}
			}
			region.initSubRegions(options.IsPlayer, options.IsPlayer);
			region.transformRegion(options.OffsetX, options.OffsetY, options.Rotation);
			return region;
		}

		// simple spawn implementation
		function placePlayersInFormation( _playerCharacters, _region )
		{
			_region.clearArea();
			_region.downsizeArea();

			local allTiles = _region.getAllTiles();

			local placedActors = 0;
			foreach (player in _playerCharacters)
			{
				local tile = null;
				if (_region.RandomPosition)
				{
					tile = _region.findEmptyTile();
				}
				else
				{
					local index = player.getPlaceInFormation();
					if (index >= allTiles.len()) continue;
					tile = allTiles[index];
				}
				if (tile == null) break;;
				if (!tile.IsEmpty) continue;

				::Tactical.addEntityToMap(player, tile.Coords.X, tile.Coords.Y);
				++placedActors;
			}

			::logWarning("Hardened: placed " + placedActors + " Players ");

			if (_playerCharacters.len() > placedActors)
			{
				::logWarning("Hardened: " + (_playerCharacters.len() - placedActors) + " could not be placed because there was no space");
			}
		}

		function placeNPCsInFormation( _entityDefs, _region )
		{
			::logWarning("Hardened: placeNPCsInFormation " + _entityDefs.len() + " " + _region.getAllTiles().len());
			// _region.clearArea();
			_region.downsizeArea();

			local placedActors = 0;
			local entityIndex = 0;

			for (local index = _entityDefs.len() - 1; index >= 0; --index)
			{
				local entityDef = _entityDefs[index];
				if (_region.placeTroop(entityDef, true))
				{
					++placedActors;
					_entityDefs.remove(index);
				}
			}

			for (local index = _entityDefs.len() - 1; index >= 0; --index)
			{
				local entityDef = _entityDefs[index];
				if (_region.placeTroop(entityDef, false))
				{
					++placedActors;
					_entityDefs.remove(index);
				}
			}

			::logWarning("Hardened: placed " + placedActors + " NPCs");

			if (_entityDefs.len() > placedActors)
			{
				::logWarning("Hardened: " + (_entityDefs.len() - placedActors) + " could not be placed because there was no space");
			}
		}

	// Private
		// Create a hexagonal region around the center of the map
		function createRegionHexagonal( _radiusMax, _radiusMin = 0 )
		{
			local region = ::Hardened.Tactical.Region.Region(::Hardened.Tactical.Region.Shape.Hexagon);
			region.CreationParameters.RadiusMin = _radiusMin;
			region.CreationParameters.RadiusMax = _radiusMax;

			local center = ::Hardened.Tactical.MapInfo.m.CenterTile;
			foreach (tile in ::Hardened.Tactical.MapInfo.getAllTiles())
			{
				local distanceToCenter = center.getDistanceTo(tile);
				if (distanceToCenter < _radiusMin) continue;
				if (distanceToCenter > _radiusMax) continue;

				region.Tiles.push(tile);
			}

			// We randomize validTiles, so that we have a fresh random list of tiles to iterate over for trying to place the settlement
			// This prevents accidentally checking the same tile multiples times
			// ::MSU.Array.shuffle(validTiles);
			// Todo: find a good place for this

			return region;
		}

		// Create a rectengular region whose rightmost center tile is the center of the map
		function createRegionPortrait( _width, _height )
		{
			local yOffset = -::Math.floor(_height / 2.0);
			local xOffset = -_width + 1;
			local bottomLeft = ::Tactical.getTileSquare(
				::Hardened.Tactical.MapInfo.m.CenterTile.SquareCoords.X + xOffset,
				::Hardened.Tactical.MapInfo.m.CenterTile.SquareCoords.Y + yOffset
			);

			local region = ::Hardened.Tactical.Region.Region(::Hardened.Tactical.Region.Shape.Portrait);
			for (local x = bottomLeft.SquareCoords.X; x < bottomLeft.SquareCoords.X + _width; ++x)
			{
				for (local y = bottomLeft.SquareCoords.Y; y < bottomLeft.SquareCoords.Y + _height; ++y)
				{
					region.Tiles.push(::Tactical.getTileSquare(x, y));
				}
			}

			return region;
		}

		// Create a rectengular region whose bottom center tile is the center of the map
		function createRegionLandscape( _width, _height )
		{
			local yOffset = 0;
			local xOffset = -::Math.floor(_width / 2.0);
			local bottomLeft = ::Tactical.getTileSquare(
				::Hardened.Tactical.MapInfo.m.CenterTile.SquareCoords.X + xOffset,
				::Hardened.Tactical.MapInfo.m.CenterTile.SquareCoords.Y + yOffset
			);

			local region = ::Hardened.Tactical.Region.Region(::Hardened.Tactical.Region.Shape.Landscape);
			for (local x = bottomLeft.SquareCoords.X; x < bottomLeft.SquareCoords.X + _width; ++x)
			{
				for (local y = bottomLeft.SquareCoords.Y; y < bottomLeft.SquareCoords.Y + _height; ++y)
				{
					region.Tiles.push(::Tactical.getTileSquare(x, y));
				}
			}

			return region;
		}

	Region = class {
		Shape = null;
		Tiles = null;
		SubRegions = null;
		RandomPosition = false;

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
		FormationRole = {
			Front = "HD_Front",		// Melee, Shield
			Flank = "HD_Flank",		// Fencer, Wolfrider, Dogs
			Backline = "HD_Backline",	// Polearmer, Thrower,
			Center = "HD_Center",		// Leader, Standard Bearer
			Ranged = "HD_Ranged",		// Archers
			Siege = "HD_Siege",		// Mortar, Necromancer, Shamans
			Random = "HD_Random",		// Vanilla uses this
		};

		FillUpOrder = [];

		// Siege -> Center -> Ranged -> Backline -> Flank -> Front
		//	-> Flank -> Backline -> Ranged -> Center -> Siege

		/*
		- Rows are filled from Center to Border
		- Loop 1 - Strict
			- Siege -> Center -> Ranged -> Backline -> Flank -> Front
		- Loop 2 - Fill Up
			- Siege -> Center -> Ranged -> Backline -> Flank -> Front
		- Loop 4 - Random
			- Place all Random
		*/

		constructor( _shape )
		{
			this.Shape = _shape;
			this.Tiles = [];
			this.SubRegions = {};
			foreach (key, value in this.FormationRole)
			{
				this.SubRegions[key] <- [];
			}

			this.FillUpOrder = [
				this.FormationRole.Front,
				this.FormationRole.Flank,
				this.FormationRole.Backline,
				this.FormationRole.Ranged,
				this.FormationRole.Center,
				this.FormationRole.Siege,
			];
		}

		// Public
			// Must be called, before this region is transformed around
			function initSubRegions( _isReversed = false, _useSingleRegion = false )
			{
				// Prefer raised/covered positions for the type of Ranged

				this.SubRegions = {};
				foreach (key, value in this.FormationRole)
				{
					this.SubRegions[value] <- [];
				}

				if (_isReversed)
				{
					this.Tiles.reverse();		// Regions are normally starting bottom left. But we need it exactly inversed for the player
				}

				if (_useSingleRegion)
				{
					this.SubRegions[this.FormationRole.Front].extend(this.Tiles);
					return;
				}

				local centerTile = ::Hardened.Tactical.MapInfo.m.CenterTile;
				foreach (tile in this.Tiles)
				{
					if (this.Shape == ::Hardened.Tactical.Region.Shape.Portrait)
					{
						switch (tile.SquareCoords.X)
						{
							case centerTile.SquareCoords.X:
								this.SubRegions[this.FormationRole.Front].push(tile);
								break;
							case centerTile.SquareCoords.X - 1:
								this.SubRegions[this.FormationRole.Backline].push(tile);
								break;
							case centerTile.SquareCoords.X - 2:
								this.SubRegions[this.FormationRole.Ranged].push(tile);
								break;
							case centerTile.SquareCoords.X - 3:
								this.SubRegions[this.FormationRole.Siege].push(tile);
								break;
							default:
								this.SubRegions[this.FormationRole.Random].push(tile);
						}
					}
					else if (this.Shape == ::Hardened.Tactical.Region.Shape.Landscape)
					{
						switch (tile.SquareCoords.Y)
						{
							case centerTile.SquareCoords.Y:
								this.SubRegions[this.FormationRole.Front].push(tile);
								break;
							case centerTile.SquareCoords.Y + 1:
								this.SubRegions[this.FormationRole.Backline].push(tile);
								break;
							case centerTile.SquareCoords.Y + 2:
								this.SubRegions[this.FormationRole.Ranged].push(tile);
								break;
							case centerTile.SquareCoords.Y + 3:
								this.SubRegions[this.FormationRole.Siege].push(tile);
								break;
							default:
								this.SubRegions[this.FormationRole.Random].push(tile);
						}
					}
					else if (this.Shape == ::Hardened.Tactical.Region.Shape.Hexagon)
					{
						local distanceToCenter = tile.getDistanceTo(centerTile);
						distanceToCenter = ::Math.clamp(distanceToCenter, this.CreationParameters.RadiusMin, this.CreationParameters.RadiusMax);
						switch (distanceToCenter)
						{
							case this.CreationParameters.RadiusMax:
								this.SubRegions[this.FormationRole.Front].push(tile);
								break;
							case this.CreationParameters.RadiusMax - 1:
								this.SubRegions[this.FormationRole.Backline].push(tile);
								break;
							case this.CreationParameters.RadiusMax - 2:
								this.SubRegions[this.FormationRole.Ranged].push(tile);
								break;
							case this.CreationParameters.RadiusMax - 3:
								this.SubRegions[this.FormationRole.Siege].push(tile);
								break;
							default:
								this.SubRegions[this.FormationRole.Random].push(tile);
						}
					}
				}
				::logWarning("Hardened: discovered " + this.getAllTiles().len() + " tiles");

				foreach (key, value in this.SubRegions)
				{
					this.sortByDistanceToCenter(value, centerTile);
				}
			}

			function transformRegion( _offsetX, _offsetY, _rotation = 0 )
			{
				local offsetTiles = [];

				foreach (tile in this.Tiles)
				{
					if (!::Tactical.isValidTileSquare(tile.SquareCoords.X + _offsetX, tile.SquareCoords.Y + _offsetY))
					{
						::logError("Hardened: _offsetX " + _offsetX + " and _offsetY " + _offsetY + " produced an invalid tile for a region! Tile was skipped.");
						return;
					}

					offsetTiles.push(::Tactical.getTileSquare(tile.SquareCoords.X + _offsetX, tile.SquareCoords.Y + _offsetY));
				}

				this.Tiles = offsetTiles;

				foreach (key, subRegion in this.SubRegions)
				{
					local offsetTiles = [];

					foreach (tile in subRegion)
					{
						offsetTiles.push(::Tactical.getTileSquare(tile.SquareCoords.X + _offsetX, tile.SquareCoords.Y + _offsetY));
					}

					this.SubRegions[key] = offsetTiles;
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
						return this.FormationRole.Front;
					case 1:
						return this.FormationRole.Backline;
					case 2:
						return this.FormationRole.Ranged;
					case 3:
						return this.FormationRole.Siege;
					case -2:
						return this.FormationRole.Random;
					default:
						return this.FormationRole.Front;
				}
			}

			function getAllTiles()
			{
				// return this.Tiles;	// temp solution to allow player characters spawning

				local combinedArray = [];
				foreach (key, value in this.SubRegions)
				{
					combinedArray.extend(value);
				}

				if (combinedArray.len() == 0) return this.Tiles;	// temp solution to allow player characters spawning

				return combinedArray;
			}

			function placeTroop( _troopDef, _strict )
			{
				local validTile = this.findEmptyTile(_troopDef, _strict);
				if (validTile == null)
				{
					return false;
				}

				local entity = ::Tactical.spawnEntity(_troopDef.Script, validTile.Coords.X, validTile.Coords.Y);
				::Tactical.Entities.setupEntity(entity, _troopDef);
				return true;
			}

		// Private
			function rotateAllTiles( _clockwise )
			{
				foreach (key, subRegionTiles in this.SubRegions)
				{
					local rotatedTiles = [];

					local ccCenterTile = ::Hardened.Tactical.CubeCoordinates.fromTacticalTile(::Hardened.Tactical.MapInfo.m.CenterTile);
					foreach (tile in subRegionTiles)
					{
						local ccTile = ::Hardened.Tactical.CubeCoordinates.fromTacticalTile(tile);
						if (_clockwise)
						{
							ccTile.rotateClockWise(ccCenterTile);
						}
						else
						{
							ccTile.rotateCounterClockWise(ccCenterTile);
						}
						rotatedTiles.push(::Hardened.Tactical.CubeCoordinates.toTacticalTile(ccTile));
					}

					this.SubRegions[key] = rotatedTiles;
				}
			}

			// Remove all objects from this region and a border around them of _borderSize distance
			function clearArea( _borderSize = 0 )
			{
				local affectedTiles = this.getAllTiles();	// Todo: respect _borderSize
				foreach (tile in affectedTiles)
				{
					tile.removeObject();
				}
			}

			function downsizeArea(  _borderSize = 0 )
			{
				local affectedTiles = this.getAllTiles();	// Todo: respect _borderSize

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

			function sortByDistanceToCenter( _tileArray, _centerTile = null )
			{
				if (_tileArray.len() == 0) return;

				if (_centerTile == null)
				{
					local center = { X = 0, Y = 0 };
					// First we calculate the average center tile of all tiles of this Region

					foreach (tile in _tileArray)
					{
						center.X += tile.SquareCoords.X;
						center.Y += tile.SquareCoords.Y;
					}
					center.X /= ::Math.round(_tileArray.len());
					center.Y /= ::Math.round(_tileArray.len());
					_centerTile = ::Tactical.getTileSquare(center.X, center.Y)
				}

				local sort = function( _a, _b )
				{
					if (_a.getDistanceTo(_centerTile) < _b.getDistanceTo(_centerTile))
					{
						return -1;
					}
					else if (_a.getDistanceTo(_centerTile) > _b.getDistanceTo(_centerTile))
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
					::logWarning("Hardened: find random empty tile")
					local validTiles = [];
					foreach (tile in this.Tiles)
					{
						if (!tile.IsEmpty) continue;
						validTiles.push(tile);
					}
					return validTiles.len() == 0 ? null : ::MSU.Array.rand(validTiles);
				}

				local formationRole = "HD_FormationRole" in _troopDef ? _troopDef.HD_FormationRole : this.translateVanillaRow(_troopDef.Row);

				foreach (tile in this.SubRegions[formationRole])
				{
					if (!tile.IsEmpty) continue;

					// ::logInfo("Hardened: found strict empty tile in role " + formationRole);
					return tile;
				}

				if (_strict) return null;

				foreach (role in this.FillUpOrder)
				{
					foreach (tile in this.SubRegions[role])
					{
						if (!tile.IsEmpty) continue;

						// ::logInfo("Hardened: found non-strict empty tile in role " + role);
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
						if (!tile.isSameTileAs(otherTile)) continue;

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
						if (tile.isSameTileAs(otherTile)) continue;

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
						if (!tile.isSameTileAs(otherTile)) continue;

						newTiles.push(tile);
						break;
					}
				}
				this.Tiles = newTiles;
			}

			// Remove all tiles from subregions, that are no longer present in this.Tiles. This can happen during intersect and exclude calls
			function synchronizeSubRegions()
			{
				::logWarning("Hardened: synchronizeSubRegions");
				foreach (subregion in this.SubRegions)
				{
					for (local index = subregion.len() - 1; index >= 0; --index)
					{
						local subregionTile = subregion[index];
						local stillPresent = false;
						foreach (tile in this.Tiles)
						{
							if (tile.isSameTileAs(subregionTile))
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
}
