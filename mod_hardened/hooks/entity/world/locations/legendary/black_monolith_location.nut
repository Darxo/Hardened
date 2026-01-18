::Hardened.HooksMod.hook("scripts/entity/world/locations/legendary/black_monolith_location", function(q) {
	// Feat: Turn the tile below the black monolith and all adjacent tiles into badlands
	q.onSpawned = @(__original) function()
	{
		__original();

		local myTile = this.getTile();
		local badlandsTiles = [
			myTile,
		];
		local mapGen = ::MapGen.get(::Const.World.TerrainScript[::Const.World.TerrainType.Badlands]);

		for (local i = 0; i < 6; ++i)
		{
			local nextTile = myTile.getNextTile(i);
			badlandsTiles.push(nextTile);

			// Look tiles up to two tiles away, but those further tiles only have a 66% chance to be transformed
			for (local j = 0; j < 6; ++j)
			{
				if (::Math.rand(1, 100) > 66) continue;
				local veryNextTile = nextTile.getNextTile(j);
				if (veryNextTile.getDistanceTo(myTile) != 2) continue;
				badlandsTiles.push(veryNextTile);

				for (local k = 0; k < 6; ++k)
				{
					if (::Math.rand(1, 100) > 66) continue;
					local veryVeryNextTile = veryNextTile.getNextTile(k);
					if (veryVeryNextTile.getDistanceTo(myTile) != 3) continue;
					badlandsTiles.push(veryVeryNextTile);
				}
			}
		}

		foreach (tile in badlandsTiles)
		{
			if (tile.Type == ::Const.World.TerrainType.Shore) continue;
			if (tile.Type == ::Const.World.TerrainType.Ocean) continue;
			if (tile.Type == ::Const.World.TerrainType.Hills) continue;
			if (tile.Type == ::Const.World.TerrainType.Mountains) continue;

			tile.Type = 0;
			tile.clear();
			mapGen.fill({
				X = tile.SquareCoords.X,
				Y = tile.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = false
			}, null);
		}
	}
});
