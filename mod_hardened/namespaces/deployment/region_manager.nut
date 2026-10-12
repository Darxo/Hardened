// Static
::Hardened.Deployment.RegionManager <- {
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

		if (_shape == ::Hardened.Deployment.RegionShape.Portrait && ::Math.abs(options.Rotation) % 60 == 30)
		{
			_shape = ::Hardened.Deployment.RegionShape.Landscape;
			options.Rotation -= 90;
			local oldY = options.OffsetY;
			options.OffsetY = -options.OffsetX;		// Needs inversed
			options.OffsetX = oldY;					// Probably does not need inversion
		}

		local region = null;
		switch (_shape)
		{
			case ::Hardened.Deployment.RegionShape.Portrait:
			{
				region = this.createRegionPortrait(_width, _height);
				break;
			}
			case ::Hardened.Deployment.RegionShape.Landscape:
			{
				region = this.createRegionLandscape(_height, _width);
				break;
			}
			case ::Hardened.Deployment.RegionShape.Hexagon:	// Hexagon shape that is facing outwards
			{
				region = this.createRegionHexagonal(_height, _width);
				break;
			}
		}
		region.Tiles.reverse();		// Regions are normally starting bottom left. But the player needs it exactly the other way around. NPCs dont care.
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
			if (tile == null) break;
			if (!tile.IsEmpty) continue;

			::Tactical.addEntityToMap(player, tile.Coords.X, tile.Coords.Y);
			++placedActors;
		}

		if (_playerCharacters.len() > placedActors)
		{
			::logWarning("Hardened: " + (_playerCharacters.len() - placedActors) + " could not be placed because there was no space");
		}
	}

	function placeNPCsInFormation( _entityDefs, _region )
	{
		::logWarning("Hardened: placeNPCsInFormation _entityDefs " + _entityDefs.len());
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

		if (_entityDefs.len() > placedActors)
		{
			::logWarning("Hardened: " + (_entityDefs.len() - placedActors) + " could not be placed because there was no space");
		}
	}

// Private
	// Create a hexagonal region around the center of the map
	function createRegionHexagonal( _radiusMax, _radiusMin = 0 )
	{
		local region = ::Hardened.Deployment.Region(::Hardened.Deployment.RegionShape.Hexagon);
		region.CreationParameters.RadiusMin = _radiusMin;
		region.CreationParameters.RadiusMax = _radiusMax;

		local center = ::Hardened.Tactical.MapInfo.m.CenterTile;
		foreach (tile in ::Hardened.Tactical.MapInfo.getAllTiles())
		{
			local distanceToCenter = center.getDistanceTo(tile);
			if (distanceToCenter < _radiusMin) continue;
			if (distanceToCenter > _radiusMax) continue;

			region.Tiles.push({X = tile.SquareCoords.X, Y = tile.SquareCoords.Y});
		}

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

		local region = ::Hardened.Deployment.Region(::Hardened.Deployment.RegionShape.Portrait);
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

		local region = ::Hardened.Deployment.Region(::Hardened.Deployment.RegionShape.Landscape);
		for (local x = bottomLeft.SquareCoords.X; x < bottomLeft.SquareCoords.X + _width; ++x)
		{
			for (local y = bottomLeft.SquareCoords.Y; y < bottomLeft.SquareCoords.Y + _height; ++y)
			{
				region.Tiles.push({X = x, Y = y});
			}
		}

		return region;
	}
}
