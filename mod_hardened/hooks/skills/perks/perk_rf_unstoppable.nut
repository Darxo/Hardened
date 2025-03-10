::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_unstoppable", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original()

		foreach (index, entry in ret)
		{
			if (entry.id == 20)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Will expire upon [Recover|Skill+recover] or getting [stunned|Skill+stunned_effect], rooted, or [staggered|Skill+staggered_effect]");
				break;
			}
		}

		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("Will expire when you [wait|Concept.Wait] or end your [turn|Concept.Turn] with more than " + ::MSU.Text.colorPositive(this.getContainer().getActor().getActionPointsMax() / 2) + " [Action Points|Concept.ActionPoints] remaining"),
		});

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
