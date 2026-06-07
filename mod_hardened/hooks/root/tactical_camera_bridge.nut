/*
::Tactical.getCamera() no longer returns a fresh object each time, but instead the very same proxyTable
So we only need to hook it once
*/

/// We replace the vanilla getBestLevelForTile function with our own, as we do a much better job in finding the best camera level

local oldGetBestLevelForTile = ::Tactical.getCamera().getBestLevelForTile;
::Tactical.getCamera().getBestLevelForTile = function( _tile ) {
	local ret = oldGetBestLevelForTile(_tile);

	// The camera level should always be at least 1 higher than the tile in question, so that you can look as much uphill as possible without your tile being hidden by a hill below you
	ret = ::Math.max(ret, _tile.Level + 1);

	return ret;
}
