::Hardened.HooksMod.hook("scripts/skills/actives/rf_hold_steady_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 8;	// In Reforged this is 7
		this.m.FatigueCost = 40;	// In Reforged this is 30
		this.m.MaxRange = 4;		// In Reforged this is unused (0)
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 21)
			{
				entry.text = "Can only be used once per battle";
			}
			else if (entry.id == 22)
			{
				entry.text = ::MSU.Text.colorNegative("Has already been used this battle");
			}
		}

		return ret;
	}

	// Overwrite because we change a few things: Remove one-per-company rule; Utilize MinRange/MaxRange member;
	q.onUse = @() function( _user, _targetTile )
	{
		this.m.IsSpent = true;

		local myTile = _user.getTile();
		foreach (ally in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()))
		{
			if (ally.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
			if (ally.getCurrentProperties().IsStunned) continue;

			if (ally.getTile().getDistanceTo(myTile) >= this.getMinRange() && ally.getTile().getDistanceTo(myTile) <= this.getMaxRange())
			{
				local effect = ::new("scripts/skills/effects/rf_hold_steady_effect");
				if (!ally.isTurnStarted() && !ally.isTurnDone())
				{
					// If the ally has not started their turn yet in this round, add one more turn
					// so that the effect doesn't immediately expire upon the ally's turn starting
					effect.m.TurnsLeft++;
				}
				ally.getSkills().add(effect);
			}
		}

		return true;
	}
});
