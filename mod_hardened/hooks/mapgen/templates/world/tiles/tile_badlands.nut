::Hardened.HooksMod.hook("scripts/mapgen/templates/world/tiles/tile_badlands", function(q) {
	// Overwrite, because vanilla tries to coat those tiles with a world_badlands_0 brush, which does not exist
	q.onFirstPass = @() function( _rect )
	{
		local tile = ::World.getTileSquare(_rect.X, _rect.Y);
		if (tile.Type != 0) return __original( _rect );		// Same check as vanilla

		tile.Type = ::Const.World.TerrainType.Badlands;
		tile.TacticalType = ::Const.World.TerrainTacticalType.Badlands;
		// Vanilla Fix: make tile_badlands spawn actual badlands-looking tiles, instead of defaulting to ocean tiles
		local brushList = ::MSU.Class.WeightedContainer([
			[12, "world_swamp_01"],
			[12, "world_swamp_02"],
			[12, "world_swamp_03"],
		]);
		tile.setBrush(brushList.roll());
		tile.IsFlipped = ::Math.rand(0, 1) == 1;
	}
});
