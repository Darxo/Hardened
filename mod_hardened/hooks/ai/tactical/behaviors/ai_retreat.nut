::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_retreat", function(q) {
	q.m.HD_AttemptsThisTurn <- 0;

	q.onBeforeExecute = @(__original) function( _entity )
	{
		__original(_entity);

		if (::Hardened.util.willBeAttackedLeavingZoneOfControl(_entity))
		{
			++this.m.HD_AttemptsThisTurn;
		}
	}

	q.onEvaluate = @(__original) function( _entity )	// This function is a generator.
	{
		// Fix: We need to slightly adjust the vanilla ai_retreat behavior, because it looks in a hard coded way for the lindwurm tail
		// 		And in Hardened, the Tail can actually be missing/null, while the head still exists
		local oldEntityType = _entity.getType();
		// Switcheroo to prevent the lindwurm head from checking its tail when that tail does not exist anymore
		if (_entity.getType() == ::Const.EntityType.Lindwurm && ::MSU.isNull(_entity.getTail()))
		{
			_entity.m.Type = 0;
		}

		// If the entity is not in a Zone of Control or is not fleeing, then the vanilla behavior will be used
		if (!_entity.HD_isEngagedInMelee() || _entity.getMoraleState() != ::Const.MoraleState.Fleeing)
		{
			local generator = __original(_entity);	// Get the original generator
			local ret = resume generator;	// Variable to hold the value yielded by the generator
			_entity.m.Type = oldEntityType;	// The Lindwurm type handling happens during the first loop

			// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
			while (ret == null)
			{
				yield ret;
				ret = resume generator;
			}
			return ret;
		}

		// Feat: We stop NPCs trying to retreat out of zone of control, after a few tries
		if (_entity.getFaction() != ::Const.Faction.Player)
		{
			// This condition is new, we now use a similar attemts counter as ai_flee
			if (this.m.HD_AttemptsThisTurn >= ::Const.AI.Agent.MaxFleeAttemptsPerTurn) return ::Const.AI.Behavior.Score.Zero;

			// We call this copy of a vanilla check early, because it can otherwise interfere with our mockObject, triggering it early
			if (::Const.AI.NoRetreatMode) return ::Const.AI.Behavior.Score.Zero;
			if (::Tactical.State.getStrategicProperties() != null && ::Tactical.State.getStrategicProperties().IsArenaMode) return ::Const.AI.Behavior.Score.Zero;
		}

		// Vanilla Fix: A fleeing actor will skip zone of control checks, so that they are able to escape when close to the border
		// Our goal is to prevent vanilla from returning Zero, when _entity is in ZoC (guaranteed at this point in the code)
		// The best way to do that is to make getFaction return "Player" very briefly as that is part of the vanilla check
		// That function is called multiple times in __orignal. We target the second time it appears
		// The first time, `getFaction` is called, is filtered out further up
		// The second time `getFaction` is called, happens only, while we are in a zone of control (guaranteed at this point in the code)
		local mockObject = ::Hardened.mockFunction(_entity, "getFaction", function() {
			return { done = true, value = ::Const.Faction.Player };
		});

		local generator = __original(_entity);	// Get the original generator
		local ret = resume generator;	// Variable to hold the value yielded by the generator

		mockObject.cleanup();			// The getFaction check happens during the first loop
		_entity.m.Type = oldEntityType;	// The Lindwurm type handling happens during the first loop

		// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
		while (ret == null)
		{
			yield ret;
			ret = resume generator;
		}

		return ret;
	}

	q.findRetreatToPosition = @(__original) function( _entity )		// This function is a generator.
	{
		local generator;
		if (::Tactical.State.m.HD_IsUsingHexagonLayout)
		{
			generator = this.HD_findRetreatToPositions(_entity);	// Use a custom generator that works with hexagon shaped maps
		}
		else
		{
			generator = __original(_entity);	// Get the original generator
		}

		local ret = resume generator;	// Variable to hold the value yielded by the generator
		// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
		while (ret == null)
		{
			yield ret;
			ret = resume generator;
		}
		return ret;
	}

	q.onTurnStarted = @(__original) function()
	{
		__original();
		this.m.HD_AttemptsThisTurn = 0;
	}

	q.isAtMapBorder = @(__original) function( _entity )
	{
		// We hijack the isAtMapBorder function to introduce a new condition:
		//	You can no longer retreat, while in zone of control of another character
		if (::Hardened.util.willBeAttackedLeavingZoneOfControl(_entity)) return false;

		return ::Hardened.Tactical.MapInfo.isFleeTile(_entity.getTile());
	}

// New Functions
	// Mostly a replica of the vanilla findRetreatToPositions, but working with hexagon shaped maps
	q.HD_findRetreatToPositions <- function( _entity )	// Function is a generator.
	{
		local time = ::Time.getExactTime();
		local myTile = _entity.getTile();
		local opponents = [];
		local mapSize = ::Tactical.getMapSize();
		local instances = ::Tactical.Entities.getAllInstances();
		local dirs = [ 0, 0, 0, 0, 0, 0 ];
		for (local i = 1; i < instances.len(); ++i)
		{
			if (_entity.getAlliedFactions().find(i) != null) continue;

			foreach (opponent in instances[i])
			{
				if (myTile.getDistanceTo(opponent.getTile()) <= 20 && !isKindOf(opponent, "alp"))
				{
					opponents.push(opponent);
				}

				local dir = myTile.getDirection8To(opponent.getTile());

				switch (dir)
				{
					case Const.Direction8.W:
						dirs[Const.Direction.NW] += 4;
						dirs[Const.Direction.SW] += 4;
						break;
					case Const.Direction8.E:
						dirs[Const.Direction.NE] += 4;
						dirs[Const.Direction.SE] += 4;
						break;
					default:
						local dir = myTile.getDirectionTo(opponent.getTile());
						local dir_left = dir - 1 >= 0 ? dir - 1 : 6 - 1;
						local dir_right = dir + 1 < 6 ? dir + 1 : 0;

						dirs[dir] += 4;
						dirs[dir_left] += 3;
						dirs[dir_right] += 3;
						break;
				}
			}
		}

		local ap = _entity.getActionPoints();
		// This Part is different from Vanilla
			local targets = [];
			foreach (tile in ::Hardened.Tactical.MapInfo.getFleeTiles())
			{
				if (!tile.IsEmpty) continue;
				local d = myTile.getDistanceTo(tile);
				targets.push({ Tile = tile, Score = d * 2 <= ap ? 0 : d, Dir = d * 2 <= ap ? 0 : dirs[myTile.getDirectionTo(tile)] });
			}

		targets.sort(onSortByLowestScore);

		local navigator	= ::Tactical.getNavigator();
		local attempts = 0;
		local bestTarget = null, bestCost = 9000, bestDanger = 9000;

		foreach (target in targets)
		{
			++attempts;

			if (attempts > Const.AI.Behavior.RetreatSoftMaxAttempts && (bestDanger == 0 || attempts > Const.AI.Behavior.RetreatHardMaxAttempts))
				break;

			//logInfo("dir: " + Const.Strings.Direction[myTile.getDirectionTo(target.Tile)]);

			// !YIELD
			if (isAllottedTimeReached(time))
			{
				yield null;
				time = ::Time.getExactTime();
			}

			local settings						= navigator.createSettings();
			settings.ActionPointCosts			= _entity.getActionPointCosts();
			settings.FatigueCosts				= _entity.getFatigueCosts();
			settings.FatigueCostFactor			= Const.Movement.FatigueCostFactor;
			settings.ActionPointCostPerLevel	= _entity.getLevelActionPointCost();
			settings.FatigueCostPerLevel		= _entity.getLevelFatigueCost();
			settings.AllowZoneOfControlPassing	= true;
			settings.ZoneOfControlCost			= Const.AI.Behavior.ZoneOfControlAPPenalty * 4;
			settings.AlliedFactions				= _entity.getAlliedFactions();
			settings.Faction					= _entity.getFaction();
			settings.HeatCost					= this.getAgent().isUsingHeat() ? Const.AI.Behavior.EngageHeatCost : 0;

			if (!navigator.findPath(myTile, target.Tile, settings, 0))
				continue;

			local movementCosts = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());

			if (movementCosts.Tiles == 0 || movementCosts.End.isSameTileAs(myTile))
				continue;

			if (movementCosts.ActionPointsRequired <= bestCost && (movementCosts.End.Coords.X == 0 || movementCosts.End.Coords.Y == 0 || movementCosts.End.Coords.X == mapSize.X - 1 || movementCosts.End.Coords.Y == mapSize.Y - 1))
			{
				bestTarget = target.Tile;
				bestCost = movementCosts.ActionPointsRequired;
				bestDanger = 0;
				continue;
			}

			if (movementCosts.ActionPointsRequired <= bestCost || bestDanger > 0)
			{
				local danger = 0.0;

				if (!movementCosts.IsComplete)
				{
					foreach (opponent in opponents)
					{
						local turns = queryActorTurnsNearTarget(opponent, movementCosts.End, _entity);

						if (turns.Turns <= 2.0)
							danger += 2.0 - turns.Turns;

						if (turns.Turns <= 1.0)
							danger += 1.0;

						//if (turns.Turns <= 1.0)
						//	++danger;
					}
				}

				if (danger < bestDanger || (danger <= bestDanger && movementCosts.ActionPointsRequired < bestCost))
				{
					bestTarget = target.Tile;
					bestCost = movementCosts.ActionPointsRequired;
					bestDanger = danger;
				}
			}
		}

		//logInfo("best danger: " + bestDanger);

		if (bestTarget != null)
		{
			this.m.TargetTile = bestTarget;
		}

		return true;
	}
});
