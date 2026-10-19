::Hardened.HooksMod.hook("scripts/mapgen/templates/tactical/tactical_quarry", function(q) {
	q.fill = @(__original) { function fill( _rect, _properties, _pass = 1 )
	{
		if (!this.m.HD_IsUsingHexagonLayout)
		{
			return __original(_rect, _properties, _pass);
		}

		local tile1 = this.MapGen.get("tactical.tile.stone1");
		local tile2 = this.MapGen.get("tactical.tile.stone2");
		local center = ::Hardened.Tactical.MapInfo.m.CenterTile;
		foreach (tile in this.HD_getAllTiles(_rect))
		{
			local distanceToCenter = tile.getDistanceTo(center);
			if (distanceToCenter == ::Hardened.Tactical.MapInfo.m.HexagonRadius)
			{
				tile.Level = 1;
			}
			else if (distanceToCenter == ::Hardened.Tactical.MapInfo.m.HexagonRadius - 1 && ::Math.rand(1, 100) <= 50)
			{
				tile.Level = 1;
			}
			else if (distanceToCenter == ::Hardened.Tactical.MapInfo.m.HexagonRadius - 2 && ::Math.rand(1, 100) <= 20)
			{
				tile.Level = 1;
			}

			local chosenBrush = ::Math.rand(1, 100) < 60 ? tile1 : tile2;
			chosenBrush.fill({
				X = tile.SquareCoords.X,
				Y = tile.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = ::Math.rand(1, 5) != 1,
			}, _properties);
		}

		this.makeBordersImpassable(_rect);
	}}.fill;
});
