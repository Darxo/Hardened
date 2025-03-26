::Hardened.HooksMod.hook("scripts/skills/actives/rf_blitzkrieg_skill", function(q) {
	// Public
	q.m.FatigueBuildUp <- 10;

	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 9;	// In Reforged this is 7
		this.m.FatigueCost = 50;	// In Reforged this is 30
		this.m.MaxRange = 4;		// In Reforged this is unused (0)
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("You and allies of your faction within " + ::MSU.Text.colorPositive("4") + " tiles gain the [Adrenaline|Skill+adrenaline_effect] effect until they start their turn in the next round");
			}
			else if (entry.id == 21)
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

	// Overwrite because we change a few things: Remove one-per-company rule; Utilize MinRange/MaxRange member; Remove available fatigue requirement; Fatigue build-up
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
				ally.setFatigue(::Math.min(ally.getFatigueMax(), ally.getFatigue() + this.m.FatigueBuildUp));
				local effect = ::new("scripts/skills/effects/adrenaline_effect");
				if (!ally.isTurnStarted() && !ally.isTurnDone())
				{
					effect.m.TurnsLeft++;
				}
				ally.getSkills().add(effect);
			}
		}

		return true;
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.IsSpent = false;
	}
});
