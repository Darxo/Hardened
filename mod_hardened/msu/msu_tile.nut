// Get all tiles, that are within a _radius of _tile
// A radius of 0 would only return _tile; A radius of 1 would result in up to 7 tiles (if we are not at the map border)
::MSU.Tile.HD_getRadiusTiles <- function( _tile, _radius = 0 )
{
	local ret = [_tile];
	local newTiles = [];	// We need a seperate array for new entries, to save some performance by not doing too many neighbor checks per distance

	// Idea: For each distance, we go through all existing tiles, and check whether their neighbors
	for (local distance = 1; distance <= _radius; ++distance)
	{
		foreach (existingTile in ret)
		{
			foreach (neighbor in ::MSU.Tile.getNeighbors(existingTile))
			{
				if (neighbor.getDistanceTo(_tile) != distance) continue;

				// We make sure we haven't already encountered- and added this tile
				local tileAlreadyExists = false;
				foreach (existingTile in newTiles)
				{
					if (!neighbor.isSameTileAs(existingTile)) continue;

					tileAlreadyExists = true;
					break;
				}
				if (!tileAlreadyExists) newTiles.push(neighbor);
			}
		}

		ret.extend(newTiles);
		newTiles = [];
	}

	return ret;
}
