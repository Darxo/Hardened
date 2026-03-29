::Hardened.HooksMod.hook("scripts/skills/actives/rf_blitzkrieg_skill", function(q) {
	// Public
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
			else if (entry.id == 20)
			{
				entry.icon = "ui/icons/unlocked_small.png";		// Reforged: "ui/icons/warning.png"
			}
			else if (entry.id == 21)
			{
				if (this.m.IsSpent)
				{
					entry.icon = "ui/icons/warning.png";
					entry.text = "Cannot be used, because you already used this skill";
				}
				else
				{
					entry.icon = "ui/icons/unlocked_small.png";
					entry.text = "Can only be used once per battle";
				}
			}
		}

		foreach (key, entry in ret)
		{
			if (entry.id == 22)
			{
				ret.remove(key);
				break;
			}
		}

		return ret;
	}

	// Overwrite because we change a few things: Remove one-per-company rule; Utilize MinRange/MaxRange member; Remove available fatigue requirement; Remove Fatigue build-up
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
