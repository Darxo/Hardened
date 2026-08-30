// Container to store information about the current map and additional standardized functions for those
::Hardened.Tactical.MapInfo <- {
	m = {
		Shape = {
			Square = 1,		// Vanilla Default
			Hexagon = 2,
		},

		DimensionX = null,	// Total Tactical Map Size
		DimensionY = null,	// Total Tactical Map Size
		CurrentShape = null,

	// Hexagon-related
		OffsetX = 0,		// Distance of Hexagon Start from left corner
		OffsetY = 0,		// Distance of Hexagon Start from bottom corner
		HexagonRadius = null,		// Radius of the Hexagon, excluding its center
		CenterTile = null,

	// Private
		CornerTiles = [],
		FleeTiles = [],		// Reference to every tile, which was valid for fleeing at the start of combat
	}

	function init( _customRadius = null )
	{
		this.m.CurrentShape = this.m.Shape.Square;

		this.m.DimensionX = ::Tactical.getMapSize().X;
		this.m.DimensionY = ::Tactical.getMapSize().Y;

		if (_customRadius == null) _customRadius = ::Math.ceil(::Math.min(this.m.DimensionX, this.m.DimensionY) / 2.0) - 1;
		this.m.HexagonRadius = _customRadius;
		this.m.CenterTile = ::Tactical.getTileSquare(this.m.OffsetX + _customRadius, this.m.OffsetY + _customRadius);
	}

	function calculateCornerTiles()
	{
		this.m.CornerTiles = [];

		if (this.m.CurrentShape == this.m.Shape.Square)
		{
			local size = ::Tactical.getMapSize();
			this.m.CornerTiles.push(::Tactical.getTileSquare(0, 0));
			this.m.CornerTiles.push(::Tactical.getTileSquare(0, size.Y -1));
			this.m.CornerTiles.push(::Tactical.getTileSquare(size.X - 1, size.Y - 1));
			this.m.CornerTiles.push(::Tactical.getTileSquare(size.X - 1, 0));
		}
	}

// Public Utility Functions
	function isFleeTile( _tile )
	{
		if (_tile.Type == ::Const.World.TerrainType.Impassable) return false;

		local neighbors = ::MSU.Tile.getNeighbors(_tile);
		if (neighbors.len() < 6) return true;

		foreach (neighbor in ::MSU.Tile.getNeighbors(_tile))
		{
			if (neighbor.Type == ::Const.World.TerrainType.Impassable) return true;
		}

		return false;
	}

	function isTileIsolated( _tile )
	{
		if (_tile.Level < 0) return true;
		if (_tile.Level > 3) return true;
		if (_tile.Type == ::Const.World.TerrainType.Impassable) return true;

		local isCompletelyIsolated = true;
		foreach (nextTile in ::MSU.Tile.getNeighbors(_tile))
		{
			if (::Math.abs(nextTile.Level - _tile.Level) <= 1)
			{
				isCompletelyIsolated = false;
				break;
			}
		}
		if (isCompletelyIsolated) return true;

		// Hacky way, similar to Vanilla, to make the center tiles of arena maps never be considered isolated
		if (_tile.Level == 0)
		{
			local isArena = true;
			foreach (cornerTile in this.getCornerTiles())
			{
				if (cornerTile.Level != 3)
				{
					isArena = false;
					break;
				}
			}
			if (isArena) return false;
		}

		local allFactions = [];
		for (local i = 0; i < 32; ++i)
		{
			allFactions.push(i);
		}

		local navigator = ::Tactical.getNavigator();
		local settings = navigator.createSettings();
		settings.ActionPointCosts = ::Const.SameMovementAPCost;
		settings.FatigueCosts = ::Const.PathfinderMovementFatigueCost;
		settings.AllowZoneOfControlPassing = true;
		settings.AlliedFactions = allFactions;

		foreach (cornerTile in this.getCornerTiles())
		{
			if (navigator.findPath(_tile, cornerTile, settings, 1))
			{
				return false;
			}
		}

		return true;
	}

// Private
	function spawnFleeTiles()
	{
		this.m.FleeTiles = [];

		for (local x = 0; x < this.m.DimensionX; ++x)
		{
			for (local y = 0; y < this.m.DimensionY; ++y)
			{
				local tile = ::Tactical.getTileSquare(x, y);
				if (!this.isFleeTile(tile)) continue;

				this.m.FleeTiles.push(tile);
				::Tactical.State.spawnRetreatIcon(tile);
			}
		}
	}

	function getCenter()
	{
		return this.m.CenterTile;
	}

	function getCornerTiles()
	{
		return this.m.CornerTiles;
	}

	function getRadius()
	{
		return this.m.HexagonRadius;
	}

	function getFleeTiles()
	{
		return this.m.FleeTiles;
	}
}

