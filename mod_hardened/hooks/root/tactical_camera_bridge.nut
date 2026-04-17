/*
::Tactical.getCamera() no longer returns a fresh object each time, but instead the very same proxyTable
So we only need to hook it once
*/

/// We replace the vanilla getBestLevelForTile function with our own, as we do a much better job in finding the best camera level
::Tactical.getCamera().getBestLevelForTile = ::Hardened.util.getBestLevelForTile;

