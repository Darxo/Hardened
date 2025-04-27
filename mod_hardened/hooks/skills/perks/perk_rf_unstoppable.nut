::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_unstoppable", function(q) {
	// Public
	q.m.InitiativePctPerStack <- 0.08;

	q.getTooltip = @(__original) function()
	{
		local ret = __original()

		foreach (index, entry in ret)
		{
			if (entry.id == 20)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Will expire upon using [Recover|Skill+recover] or getting [stunned|Skill+stunned_effect], rooted, or [staggered|Skill+staggered_effect]");

				local initiativeMult = this.getInitiativeMult();
				if (initiativeMult != 1.0)
				{
					ret.insert(index, {
						id = 12,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(initiativeMult) + " [Initiative|Concept.Initiative]"),
					});
				}

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

	// Overwrite, because we no longer grant a flat initiative bonus
	q.getInitiativeBonus = @() function()
	{
		return 0;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		// We don't check for the same properties as Reforged, because Reforged sets the Stacks to 0 when any check fails, in which case getInitaitiveMult should return 1.0 anyways
		_properties.InitiativeMult *= this.getInitiativeMult();
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

// New Functions
	q.getInitiativeMult <- function()
	{
		return 1.0 + this.m.Stacks * this.m.InitiativePctPerStack;
	}
});
