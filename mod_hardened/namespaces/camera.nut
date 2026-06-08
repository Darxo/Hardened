// Namespace for camera related functions
::Hardened.Camera <- {};

/// Find the ideal level for the camera, so that _actor and its important surrounding are visible
::Hardened.Camera.getBestLevelForTile <- function( _myTile )
{
	local isHiddenByHill = function( _tile )
	{
		if (!_tile.hasNextTile(::Const.Direction.S)) return false;

		return _tile.getNextTile(::Const.Direction.S).Level >= (_tile.Level + 2);
	}

	// Goal: Our Actor needs to be visible
	local minLevelForActor = 0;		// min camera level required, so that _actor is visible
	local maxLevelForActor = 3;		// max camera level, beyond which _actor is hidden by hills

	minLevelForActor = _myTile.Level;
	if (isHiddenByHill(_myTile)) maxLevelForActor = ::Math.min(maxLevelForActor, _myTile.Level + 1);
	minLevelForActor = ::Math.min(minLevelForActor, maxLevelForActor);	// We make sure, that minLevelForActor is never larger than maxLevelForActor

	// Goal: All our accessible neighboring tiles need to be visible
	local minLevelForNeighbor = 0;		// min camera level required, so that all neighbors are visible; This is currently not used, because we always prioritize maxLevel
	local maxLevelForNeighbor = 3;		// max camera level, beyond which some neighbors are hidden by hills
	foreach (nextTile in ::MSU.Tile.getNeighbors(_myTile))
	{
		// We are only interested in adjacent tiles, that we can talk to/melee attack on
		if (::Math.abs(nextTile.Level - _myTile.Level) > 1) continue;

		minLevelForNeighbor = ::Math.max(minLevelForNeighbor, nextTile.Level);
		if (isHiddenByHill(nextTile)) maxLevelForNeighbor = ::Math.min(maxLevelForNeighbor, nextTile.Level + 1);
	}

	// We decide to discard minLevelForNeighbor, because blackened/platoed tiles can theoretically still be clicked on
	local idealNeighborLevel = maxLevelForNeighbor;
	return ::Math.clamp(idealNeighborLevel, minLevelForActor, maxLevelForActor);
}

::Hardened.Camera.getBestLevelForTargeting <- function( _skill )
{
	local validTargets = [];
	foreach (otherActor in ::Tactical.Entities.getAllInstancesAsArray())
	{
		if (!otherActor.isPlacedOnMap()) continue;
		if (!_skill.isUsableOn(otherActor.getTile())) continue;

		validTargets.push(otherActor.getTile());
	}

	// Between min and max, all targets are visible
	local minRequiredLevel = 0;		// min camera level required, so that no character is sitting on a black cut-off tile
	local maxRequiredLevel = 3;		// max camera level, beyond which some character are hidden by hills

	foreach (tile in validTargets)
	{
		minRequiredLevel = ::Math.max(minRequiredLevel, tile.Level);

		if (tile.hasNextTile(::Const.Direction.S) && tile.getNextTile(::Const.Direction.S).Level >= (tile.Level + 2))
		{
			maxRequiredLevel = ::Math.min(maxRequiredLevel, tile.Level + 1);
		}
	}

	// For now we only ever return maxRequiredLevel
	// In the future we might employ some logic, where the level is returned, which displays the most characters
	return maxRequiredLevel;
}
