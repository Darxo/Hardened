::Hardened.HooksMod.hook("scripts/mapgen/templates/world/worldmap_generator", function(q) {
	q.refineTerrain = @(__original) function( _rect, _properties )
	{
		__original(_rect, _properties);

		// Vanilla Fix: Settlements at water sometimes not building a port correctly
		// Vanilla Fix: We prevent vanilla from placing roads directly onto the map border
		for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
			{
				if (x == 0 || y == 0 || x == (_rect.X + _rect.W - 1) || y == (_rect.Y + _rect.H - 1))
				{
					// We permanently change the type of all border tiles to Ocean without changing them visually,
					//	- so that ports cities have better pathfinding to the corner ocean tiles allowing them to build ports
					//	- so that roads are never built on the map border
					this.m.WorldTiles[x][y].Type = ::Const.World.TerrainType.Ocean;
				}
			}
		}
	}
});
