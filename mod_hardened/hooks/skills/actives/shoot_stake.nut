::Hardened.HooksMod.hook("scripts/skills/actives/shoot_stake", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AdditionalAccuracy += 10;	// In Reforged this is 15
		this.m.ActionPointCost -= 1;	// In Vanilla this is 3
	}

	// Overwrite because we fix the vanilla effect sometimes not working (= only checking a single position)
	q.findTileToKnockBackTo = @() function( _userTile, _targetTile )
	{
		local potentialTargets = [];
		local distanceToTarget = _userTile.getDistanceTo(_targetTile);
		foreach (potentialTile in ::MSU.Tile.getNeighbors(_targetTile))
		{
			if (!potentialTile.IsEmpty) continue;
			if (_userTile.getDistanceTo(potentialTile) <= distanceToTarget) continue;	// Knock Back destinations must further away than initial target

			local levelDifference = potentialTile.Level - _targetTile.Level;
			if (levelDifference > 1) continue;		// We can't knock back targets 2 levels upwards

			potentialTargets.push(potentialTile);
		}

		if (potentialTargets.len() != 0)
		{
			return ::MSU.Array.rand(potentialTargets);
		}

		return null;
	}
});
