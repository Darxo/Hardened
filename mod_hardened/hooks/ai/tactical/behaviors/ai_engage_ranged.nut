::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_engage_ranged", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		local generator = __original(_entity);	// Get the original generator

		local ret = resume generator;	// Variable to hold the value yielded by the generator

		// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
		while (ret == null)
		{
			yield ret;
			ret = resume generator;
		}

		if (ret == ::Const.AI.Behavior.Score.Zero) return ret;

		// Feat: If we are defending a place and the best tile to advance to would be closer to any danger, than our allies, we abort
		if (this.getStrategy().isDefending() && this.HD_isNewFrontline(_entity, this.m.TargetTile))
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		return ret;
	}

// New Functions
	// Return true, if the closest enemy at _targetTile would have us as their closest enemy from our faction
	q.HD_isNewFrontline <- function( _entity, _targetTile )
	{
		local frontlineInfo = this.HD_getFrontlineInfo(_entity, this.m.TargetTile);
		return frontlineInfo.closestEnemyDist < frontlineInfo.bestAllyDist;
	}

	q.HD_getFrontlineInfo <- function( _entity, _targetTile )
	{
		local frontlineInfo = {
			closestEnemy = null,
			closestEnemyDist = 9999,
			bestAlly = null,
			bestAllyDist = 9999,
		}

		// Find nearest enemy to the target tile
		foreach (factionActors in ::Tactical.Entities.getAllInstances())
		{
			foreach (actor in factionActors)
			{
				if (actor == null) continue;
				if (!actor.isAlive()) continue;
				if (actor.isAlliedWith(_entity)) continue;

				local distance = _targetTile.getDistanceTo(actor.getTile());
				if (distance < frontlineInfo.closestEnemyDist)
				{
					frontlineInfo.closestEnemy = actor;
					frontlineInfo.closestEnemyDist = distance;
				}
			}
		}
		if (frontlineInfo.closestEnemy == null) return frontlineInfo;

		// Determine which ally is closest to that enemy
		foreach (factionActors in ::Tactical.Entities.getAllInstances())
		{
			foreach (actor in factionActors)
			{
				if (actor == null) continue;
				if (!actor.isAlive()) continue;
				if (actor.getID() == _entity.getID()) continue;		// We ignore ourselves
				if (!actor.isAlliedWith(_entity)) continue;

				local distance = _targetTile.getDistanceTo(actor.getTile());
				if (distance < frontlineInfo.bestAllyDist)
				{
					frontlineInfo.bestAlly = actor;
					frontlineInfo.bestAllyDist = distance;
				}
			}
		}

		return frontlineInfo;
	}
});
