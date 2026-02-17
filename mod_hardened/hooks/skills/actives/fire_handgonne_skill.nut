::Hardened.HooksMod.hook("scripts/skills/actives/fire_handgonne_skill", function(q) {
	// Overwrite, because we prevent Vanilla from adding the reload skill whenever this skill is used
	// Because of stack-based-skills, those additional reloads, clog up the skill UI list otherwise
	q.onUse = @(__original) function( _user, _targetTile )
	{
		// We prevent Vanilla from adding the reload skill at this point, as in Hardened it is always present
		local mockObject = ::Hardened.mockFunction(this.getContainer(), "add", function( _skillToAdd ) {
			if (_skillToAdd.getID() == "actives.reload_handgonne")
			{
				// We just prevent this skill addition, nothing more
				return { done = true, value = null };
			}
		});

		local ret = __original(_user, _targetTile);

		mockObject.cleanup();

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		// Don't add skill for the dummy player to prevent duplicate reload skills
		if (!::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			this.getItem().addSkill(::new("scripts/skills/actives/reload_handgonne_skill"));
		}
	}

	// Overwrite, because there is no other way of skipping the Reforged changes without keepings its changes to other functions of this class
	// Feat: We rework the AoE Pattern of this skill to use pyramic shapes for any tile between axis
	q.getAffectedTiles = @() function( _targetTile )
	{
		local myTile = this.getContainer().getActor().getTile();
		local affectedTiles = [];

		// If the targeted tile is on the same hexagon axis as us, we can do the vanilla AoE shape:
		if (myTile.X == _targetTile.X || myTile.Y == _targetTile.Y || (myTile.X + myTile.Y) == (_targetTile.X + _targetTile.Y))
		{
			// Goal: We shoot on an axis, so the AoE looks something like the impact zone of a smoke bomb
			// Except, that we don't add the third tile on our axis to the area
			local dir = myTile.getDirectionTo(_targetTile);
			if (!_targetTile.hasNextTile(dir)) return [_targetTile];	// We are aiming into void/map-border, so we abort immediately

			local centreTile = _targetTile.getNextTile(dir);
			affectedTiles.push(centreTile);
			foreach (nextTile in ::MSU.Tile.getNeighbors(centreTile))
			{
				// The tile that comes after the centre tile is the only one we wanna skip/exclude for our area
				if (centreTile.hasNextTile(dir) && centreTile.getNextTile(dir).isSameTileAs(nextTile)) continue;

				affectedTiles.push(nextTile);
			}
		}
		else
		{
			// Goal: we go distance-by-distance and collect all tiles that are adjacent to already collected tiles
			// That will result in a reverse pyramid shape, which is exactly what we want
			affectedTiles.push(_targetTile);
			local newTiles = [];	// We need a seperate array for new entries, so that we dont accidentally add a whole circle of tiles with our algorithm
			local initialDistance = myTile.getDistanceTo(_targetTile);
			local maxDistance = initialDistance + 2;	// Currently this is hard-coded as we have no plans to increase the AoE of this skill

			for (local nextDistance = initialDistance + 1; nextDistance <= maxDistance; ++nextDistance)
			{
				foreach (foundTile in affectedTiles)
				{
					foreach (nextTile in ::MSU.Tile.getNeighbors(foundTile))
					{
						if (myTile.getDistanceTo(nextTile) != nextDistance) continue;	// The neighbor is not the distance we are currently interested in
						if (::Math.abs(myTile.Level - nextTile.Level) > this.m.MaxLevelDifference) continue;	// We can't hit too high/low

						// We make sure we haven't already encountered and added this tile
						// We only have to look at newTiles, because all tiles from affectedTiles, were from previous iterations
						//	which had a lower distance, which would be filtered out by the distance check right above
						local tileAlreadyExists = false;
						foreach (existingTile in newTiles)
						{
							if (!nextTile.isSameTileAs(existingTile)) continue;
							tileAlreadyExists = true;
						}
						if (!tileAlreadyExists) newTiles.push(nextTile);
					}
				}
				affectedTiles.extend(newTiles);
			}
		}

		return affectedTiles;
	}
});
