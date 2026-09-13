::Hardened.HooksMod.hook("scripts/mapgen/templates/tactical/locations/tactical_human_camp", function(q) {
	q.fill = @(__original) { function fill( _rect, _properties, _pass = 1 )
	{
		__original(_rect, _properties, _pass);

		local centerTile = ::Tactical.getTileSquare(_rect.W / 2 + _properties.ShiftX, _rect.H / 2 + _properties.ShiftY);
		local radius = ::Const.Tactical.Settings.CampRadius + _properties.AdditionalRadius;

		if (_properties.HD_HasWatchposts)
		{
			for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
			{
				for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
				{
					local tile = ::Tactical.getTileSquare(x, y);
					local distance = centerTile.getDistanceTo(tile);
					if (distance != (radius - 1)) continue;

					local tilesOnRadius = 0;
					foreach (nextTile in ::MSU.Tile.getNeighbors(tile))
					{
						if (nextTile.getDistanceTo(centerTile) == radius)
						{
							++tilesOnRadius;
						}
					}

					if (tilesOnRadius == 3)
					{
						this.HD_makeWatchpost(_rect, _properties, tile);
					}
				}
			}
		}
	}}.fill;

// New Functions
	// Helper function to turn a tile and its surroundings into a "Watchpost"
	q.HD_makeWatchpost <- function( _rect, _properties, _watchpostTile )
	{
		local centerTile = ::Tactical.getTileSquare(_rect.W / 2 + _properties.ShiftX, _rect.H / 2 + _properties.ShiftY);
		local radius = ::Const.Tactical.Settings.CampRadius + _properties.AdditionalRadius;

		local watchpostLevel = ::Math.min(3, centerTile.Level + 1);

		_watchpostTile.removeObject();
		_watchpostTile.Level = watchpostLevel;

		foreach (nextTile in ::MSU.Tile.getNeighbors(_watchpostTile))
		{
			local distance = centerTile.getDistanceTo(nextTile);
			if (distance == radius)
			{
				nextTile.Level = watchpostLevel;
				this.HD_spawnWallObject(nextTile, _properties, centerTile);
			}
			else
			{
				nextTile.removeObject();
			}
		}
	}

	q.HD_spawnWallObject <- function( _tile, _properties, _centerTile )
	{
		_tile.removeObject();
		local object;
		if (_properties.Fortification == ::Const.Tactical.FortificationType.Palisade)
		{
			object = _tile.spawnObject("entity/tactical/objects/human_camp_wall");
		}
		else if (_properties.Fortification == ::Const.Tactical.FortificationType.Walls)
		{
			object = _tile.spawnObject("entity/tactical/objects/graveyard_wall");
		}
		else if (::Math.rand(1, 100) <= 50)
		{
			object = _tile.spawnObject("entity/tactical/objects/human_camp_wall");
		}
		else
		{
			object = _tile.spawnObject("entity/tactical/objects/graveyard_wall");
		}

		local radius = ::Const.Tactical.Settings.CampRadius + _properties.AdditionalRadius;
		object.setDirBasedOnCenter(_centerTile, radius);
	}
});
