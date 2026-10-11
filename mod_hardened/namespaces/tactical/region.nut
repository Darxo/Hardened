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
			// region.Tiles.reverse();		// Regions are normally starting bottom left. But the player needs it exactly the other way around. NPCs dont care.
			region.initSubRegions();
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

				region.Tiles.push({X = tile.X, Y = tile.Y});
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
					region.Tiles.push({X = x, Y = y});
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
					region.Tiles.push({X = x, Y = y});
				}
			}

			return region;
		}

	Region = class {
		Shape = null;
		Tiles = null;		// Array of SquareCoords, so that we can deal with coords out of bound
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
			function initSubRegions()
			{
				// Prefer raised/covered positions for the type of Ranged

				this.SubRegions = {};
				foreach (key, value in this.FormationRole)
				{
					this.SubRegions[value] <- [];
				}

				local centerTile = ::Hardened.Tactical.MapInfo.m.CenterTile;
				foreach (coordPair in this.Tiles)
				{
					if (this.Shape == ::Hardened.Tactical.Region.Shape.Portrait)
					{
						switch (coordPair.X)
						{
							case centerTile.SquareCoords.X:
								this.SubRegions[this.FormationRole.Front].push(coordPair);
								break;
							case centerTile.SquareCoords.X - 1:
								this.SubRegions[this.FormationRole.Backline].push(coordPair);
								break;
							case centerTile.SquareCoords.X - 2:
								this.SubRegions[this.FormationRole.Ranged].push(coordPair);
								break;
							case centerTile.SquareCoords.X - 3:
								this.SubRegions[this.FormationRole.Siege].push(coordPair);
								break;
							default:
								this.SubRegions[this.FormationRole.Random].push(coordPair);
						}
					}
					else if (this.Shape == ::Hardened.Tactical.Region.Shape.Landscape)
					{
						switch (coordPair.Y)
						{
							case centerTile.SquareCoords.Y:
								this.SubRegions[this.FormationRole.Front].push(coordPair);
								break;
							case centerTile.SquareCoords.Y + 1:
								this.SubRegions[this.FormationRole.Backline].push(coordPair);
								break;
							case centerTile.SquareCoords.Y + 2:
								this.SubRegions[this.FormationRole.Ranged].push(coordPair);
								break;
							case centerTile.SquareCoords.Y + 3:
								this.SubRegions[this.FormationRole.Siege].push(coordPair);
								break;
							default:
								this.SubRegions[this.FormationRole.Random].push(coordPair);
						}
					}
					else if (this.Shape == ::Hardened.Tactical.Region.Shape.Hexagon)
					{
						if (!::Tactical.isValidTileSquare(coordPair.X, coordPair.Y))
						{
							this.SubRegions[this.FormationRole.Random].push(coordPair);
							continue;
						}

						local tile = ::Tactical.getTileSquare(coordPair.X, coordPair.Y);
						local distanceToCenter = tile.getDistanceTo(centerTile);
						distanceToCenter = ::Math.clamp(distanceToCenter, this.CreationParameters.RadiusMin, this.CreationParameters.RadiusMax);
						switch (distanceToCenter)
						{
							case this.CreationParameters.RadiusMax:
								this.SubRegions[this.FormationRole.Front].push(coordPair);
								break;
							case this.CreationParameters.RadiusMax - 1:
								this.SubRegions[this.FormationRole.Backline].push(coordPair);
								break;
							case this.CreationParameters.RadiusMax - 2:
								this.SubRegions[this.FormationRole.Ranged].push(coordPair);
								break;
							case this.CreationParameters.RadiusMax - 3:
								this.SubRegions[this.FormationRole.Siege].push(coordPair);
								break;
							default:
								this.SubRegions[this.FormationRole.Random].push(coordPair);
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
				foreach (tile in this.Tiles)
				{
					tile.X += _offsetX;
					tile.Y += _offsetY;
				}
/*
				foreach (key, subRegion in this.SubRegions)
				{
					local offsetTiles = [];

					foreach (tile in subRegion)
					{
						tile.X += _offsetX;
						tile.Y += _offsetY;
					}

					this.SubRegions[key] = offsetTiles;
				}*/

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

				return allTiles;
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
				local ccCenterTile = ::Hardened.Tactical.CubeCoordinates.fromTacticalTile(::Hardened.Tactical.MapInfo.m.CenterTile);
				foreach (coordPair in this.Tiles)
				{
					local ccTile = ::Hardened.Tactical.CubeCoordinates.fromSquareCoords(coordPair);
					if (_clockwise)
					{
						ccTile.rotateClockWise(ccCenterTile);
					}
					else
					{
						ccTile.rotateCounterClockWise(ccCenterTile);
					}
					coordPair.X = ccTile.X;
					coordPair.Y = ccTile.Y;
				}
			}

			// Remove all objects from this region and a border around them of _borderSize distance
			function clearArea( _borderSize = 0 )
			{
				local affectedTiles = this.getAllTiles();
				foreach (tile in affectedTiles)
				{
					tile.removeObject();
				}
			}

			function downsizeArea(  _borderSize = 0 )
			{
				local affectedTiles = this.getAllTiles();

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
					::logWarning("Hardened: find random empty tile")
					local validTiles = [];
					foreach (tile in this.getAllTiles())
					{
						if (!tile.IsEmpty) continue;
						validTiles.push(tile);
					}
					return validTiles.len() == 0 ? null : ::MSU.Array.rand(validTiles);
				}

				local formationRole = "HD_FormationRole" in _troopDef ? _troopDef.HD_FormationRole : this.translateVanillaRow(_troopDef.Row);

				foreach (tile in this.getAllTiles(formationRole))
				{
					if (!tile.IsEmpty) continue;

					// ::logInfo("Hardened: found strict empty tile in role " + formationRole);
					return tile;
				}

				if (_strict) return null;

				foreach (role in this.FillUpOrder)
				{
					foreach (tile in this.getAllTiles(role))
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
						if (tile != otherTile) continue;

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
						if (tile == otherTile) continue;

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
						if (tile != otherTile) continue;

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
							if (tile == subregionTile)
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
