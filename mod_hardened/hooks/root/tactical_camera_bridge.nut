/*
::Tactical.getCamera() no longer returns a fresh object each time, but instead the very same proxyTable
So we only need to hook it once
*/

/// We slightly adjust the return value of getBestLevelForTile to produce bette results
/// In my first tests, I had issues, where this function was not called for the first entity each round (except for first round)
///   But in later tests eventually I couldn't reproduce that anymore. I don't know what was wrong or how I fixed it
local oldGetBestLevelForTile = ::Tactical.getCamera().getBestLevelForTile;
::Tactical.getCamera().getBestLevelForTile = function( _tile ) {
	local ret = oldGetBestLevelForTile(_tile);
	return ::Math.max(_tile.Level + 1, ret);	// The return value must always be at least 1 higher than the Level of _tile
}
