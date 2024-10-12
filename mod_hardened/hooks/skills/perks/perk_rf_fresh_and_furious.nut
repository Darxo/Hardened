::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_fresh_and_furious", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueThreshold = 0.5;	// In Reforged this is 0.3
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 12)
			{
				entry.text = ::MSU.String.replace(entry.text, "starting", "ending");
			}
		}

		foreach (index, entry in ret)
		{
			if (entry.id == 11 && this.m.IsSpent)
			{
				ret.remove(index);	// Remove mention about the free skill use, because it's already been used this turn
			}
		}

		return ret;
	}

	q.isHidden = @() function()
	{
		return false;	// Always show this effect. Either it's disabled or enabled.
	}

	// Overwrite because the fatigue check no longer happens at the start of the turn
	q.onTurnStart = @() function()
	{
		this.m.IsSpent = false;	// Same as Reforged
	}

	q.onTurnEnd <- function()
	{
		this.checkFatigueThreshold();
	}

// New Functions
	q.checkFatigueThreshold <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getFatigue() >= this.m.FatigueThreshold * actor.getFatigueMax())
		{
			this.m.RequiresRecover = true;
			this.m.Icon = ::Const.Perks.findById(this.getID()).IconDisabled;
			this.m.IconMini = "";
		}
		else
		{
			this.m.Icon = ::Const.Perks.findById(this.getID()).Icon;
			this.m.IconMini = this.m.IconMiniBackup;
		}
	}
});
