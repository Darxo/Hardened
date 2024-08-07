::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_unstoppable", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original()

		foreach (index, entry in ret)
		{
			if (entry.id == 12)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Will expire upon [Recover|Skill+recover] or getting [stunned|Skill+stunned_effect], rooted, or [staggered|Skill+staggered_effect]");
				break;
			}
		}

		return ret;
	}

	// Override because it no longer always sets the stacks to 0
	q.onWaitTurn = @() function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getActionPoints() > actor.getActionPointsMax() / 2)	// Same condition as with onTurnEnd
		{
			this.m.Stacks = 0;
		}
	}
});
