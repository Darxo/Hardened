::Hardened.HooksMod.hook("scripts/mapgen/templates/world/worldmap_generator", function(q) {
	q.buildRoads = @(__original) function( _rect, _properties )
	{
		// Vanilla Fix: We prevent vanilla from placing roads directly onto the map border, by briefly switching the tile tiles of all map border tiles to something that roads will never be built on
		// This is an example seed PKAQGLWHXJ, which normally produces a borderroad at the left border. And this road is no longer positioned on the border after this fix
		local swicheroodTiles = [];
		for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
			{
				if (x == 0 || y == 0 || x == (_rect.X + _rect.W - 1) || y == (_rect.Y + _rect.H - 1))
				{
					local targetedTile = this.m.WorldTiles[x][y];
					swicheroodTiles.push({
						tile = targetedTile,
						oldType = targetedTile.Type,
					});
					targetedTile.Type = ::Const.World.TerrainType.Ocean;	// We set all border tiles to become ocean, as roads will not be build on those
				}
			}
		}

		__original(_rect, _properties);

		foreach (tileData in swicheroodTiles)	// Now we clean up all changed tiles
		{
			tileData.tile.Type = tileData.oldType;
		}
	}
});
