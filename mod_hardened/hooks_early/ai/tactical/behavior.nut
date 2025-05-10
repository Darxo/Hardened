::Hardened.HooksMod.hook("scripts/ai/tactical/behavior", function(q) {
	// _actor wants to know, how their chances are at approaching _entity, when they would be standing on the tile _target
	// @param _actor the actor, which tries to approach and maybe attack _entity
	// @param _target the destination tile of this movement attempt
	// @param _entity the entity, which _actor tries to approach and maybe attack
	// @return table containing some results of this calculation
	//
	// Overwrite, because we improve a few aspects of the vanilla function:
	//	- We calculate an accurate TurnsWithAttack, when _actor and virtualTargetTile are adjacent
	//	- We consider already spent AP, when calculating Turns and TurnsWithAttack
	//	- We consider cost of cheapest attack, when calculating TurnsWithAttack
	q.queryActorTurnsNearTarget = @() function( _actor, _virtualTargetTile, _target )
	{
		local actorTile = _actor.getTile();
		local ret = {
			Turns = 9000.0,
			TurnsWithAttack = 9000.0,
			InZonesOfControl = actorTile.getZoneOfControlCountOtherThan(_actor.getAlliedFactions()),
			InZonesOfOccupation = actorTile.getZoneOfOccupationCountOtherThan(_actor.getAlliedFactions()),
		};

		if (_actor.isNonCombatant()) return ret;

		local distance = actorTile.getDistanceTo(_virtualTargetTile);
		if (distance <= 1)
		{
			ret.Turns = 0.0;
			local cheapestAttack = _actor.getSkills().getCheapestAttack();
			local cheapestAttackAP = cheapestAttack == null ? 4 : cheapestAttack.getActionPointCost();
			if (cheapestAttackAP == 0)	// We check for this explicitely to prevent a division by 0 in the second check
			{
				ret.TurnsWithAttack = 0;	// We can attack this turn and it costs us nothing at all
			}
			else if (cheapestAttackAP <= _actor.getActionPoints())	// We can attack this turn
			{
				ret.TurnsWithAttack = cheapestAttackAP / _actor.getActionPoints();
			}
			else	// We need at least one turn (1.0). And next turn, we have all of our action points to work with
			{
				ret.TurnsWithAttack = 1.0 + cheapestAttackAP / _actor.getActionPointsMax();
			}
			return ret;
		}
		else if (distance >= 10)
		{
			return ret;
		}

		// This Settings section is exactly like Vanilla
		local targetTile = _target.getTile();
		local navigator = this.Tactical.getNavigator();
		local settings = navigator.createSettings();
		settings.ActionPointCosts = _actor.getActionPointCosts();
		settings.ActionPointCostPerLevel = _actor.getLevelActionPointCost();
		settings.FatigueCostFactor = 0.0;
		settings.AllowZoneOfControlPassing = true;
		settings.ZoneOfControlCost = 2;
		settings.AlliedFactions = _actor.getAlliedFactions();
		settings.Faction = _actor.getFaction();
		settings.TileToConsiderEmpty = targetTile;

		if (navigator.findPath(actorTile, _virtualTargetTile, settings, 1))		// Same as Vanilla
		{
			// _actor might not always have all AP in thsi turn remaining,
			// so we calculate how much he is missing and add that as a punishment on the returned turns
			local missingAP = _actor.getActionPointsMax() - _actor.getActionPoints();
			local missingAPPenalty = missingAP / _actor.getActionPointsMax();

			ret.Turns = navigator.getTurnsRequiredForPath(_actor, settings, _actor.getActionPointsMax());
			ret.Turns += missingAPPenalty;

			local cheapestAttack = _actor.getSkills().getCheapestAttack();
			local cheapestAttackAP = cheapestAttack == null ? 4 : cheapestAttack.getActionPointCost();
			local attackPenalty = cheapestAttackAP / _actor.getActionPointsMax();
			ret.TurnsWithAttack = ret.Turns + attackPenalty;
		}

		return ret;
	}
});
