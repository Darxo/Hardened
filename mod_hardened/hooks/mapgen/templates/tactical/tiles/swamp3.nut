::Hardened.HooksMod.hook("scripts/mapgen/templates/tactical/tiles/swamp3", function(q) {
	q.onFirstPass = @(__original) function( _rect )
	{
		__original(_rect);

		// Feat: We change the subtype of "Plashy Grass" (2 AP per move) into "Muddy Earth" (3 AP per move)
		// This streamlines the AP costs in swamp fights making those much easier to calculate,
		//	as those two types of ground looked too similar
		local tile = ::Tactical.getTileSquare(_rect.X, _rect.Y);
		if (tile.Type == ::Const.Tactical.TerrainType.FlatGround)
		{
			tile.Type = ::Const.Tactical.TerrainType.RoughGround;
		}
	}
});
