// Namespace for camera related functions
::Hardened.Camera <- {
	PreviousCameraLevel = null,		// Save previous camera level before previewing to return to after previewing has ended
};

/// Find the ideal level for the camera, so _tile and its important surrounding are visible
::Hardened.Camera.getBestLevelForMoving <- function( _targetedTile )
{
	// Goal: Our Actor needs to be visible
	local minLevelForActor = 0;		// min camera level required, so that _actor is visible
	local maxLevelForActor = 3;		// max camera level, beyond which _actor is hidden by hills

	minLevelForActor = _targetedTile.Level;
	if (::Hardened.Camera.isHiddenByHill(_targetedTile)) maxLevelForActor = ::Math.min(maxLevelForActor, _targetedTile.Level + 1);
	minLevelForActor = ::Math.min(minLevelForActor, maxLevelForActor);	// We make sure, that minLevelForActor is never larger than maxLevelForActor

	// Goal: All our accessible neighboring tiles need to be visible
	local minLevelForNeighbor = 0;		// min camera level required, so that all neighbors are visible; This is currently not used, because we always prioritize maxLevel
	local maxLevelForNeighbor = 3;		// max camera level, beyond which some neighbors are hidden by hills
	foreach (nextTile in ::MSU.Tile.getNeighbors(_targetedTile))
	{
		// We are only interested in adjacent tiles, that we can talk to/melee attack on
		if (::Math.abs(nextTile.Level - _targetedTile.Level) > 1) continue;

		minLevelForNeighbor = ::Math.max(minLevelForNeighbor, nextTile.Level);
		if (::Hardened.Camera.isHiddenByHill(nextTile)) maxLevelForNeighbor = ::Math.min(maxLevelForNeighbor, nextTile.Level + 1);
	}

	// We decide to discard minLevelForNeighbor, because blackened/platoed tiles can theoretically still be clicked on
	local idealNeighborLevel = maxLevelForNeighbor;
	return ::Math.clamp(idealNeighborLevel, minLevelForActor, maxLevelForActor);
}

::Hardened.Camera.getBestLevelForTargeting <- function( _skill )
{
	// First we calculate how many valid enemies are visible at each camera level
	local visibleTargetsPerLevel = array(4, 0);		// There are 4 levels in total

	foreach (tile in _skill.HD_getAllTargets())
	{
		local levelRequiredForVisibilityMax = 3;

		if (::Hardened.Camera.isHiddenByHill(tile))
		{
			levelRequiredForVisibilityMax = tile.Level + 1;
		}

		foreach (level, amount in visibleTargetsPerLevel)
		{
			if (level >= tile.Level && level <= levelRequiredForVisibilityMax)
			{
				visibleTargetsPerLevel[level]++;
			}
		}
	}

	local mostEnemies = 0;
	local bestLevel = 3;

	foreach (level, amount in visibleTargetsPerLevel)
	{
		if (amount >= mostEnemies)	// On a tie we always prefer the highest tile level possible
		{
			mostEnemies = amount;
			bestLevel = level;
		}
	}

	return bestLevel;
}

{	// Private
	/// Determine whether _tile is hidden behind a hill south of it
	::Hardened.Camera.isHiddenByHill <- function( _tile )
	{
		if (!_tile.hasNextTile(::Const.Direction.S)) return false;
		local southernTile = _tile.getNextTile(::Const.Direction.S);

		if (!southernTile.IsDiscovered) return false;
		return southernTile.Level >= (_tile.Level + 2);
	}
}
