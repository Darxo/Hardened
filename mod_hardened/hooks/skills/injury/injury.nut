::Hardened.HooksMod.hook("scripts/skills/injury/injury", function(q) {
	q.m.AffectedBodyPart <- -1;		// -1 means no location is specified. So any body part check will fail

	// Private
	q.m.RoundAdded <- 0;

	q.onAdded = @(__original) function()
	{
		__original();
		if (::Tactical.isActive())
		{
			this.m.RoundAdded = ::Tactical.TurnSequenceBar.getCurrentRound();
		}
		else
		{
			this.m.IsFresh = false;
		}
	}

	q.getName = @(__original) function()
	{
		local ret = __original();

		if (this.isFresh() && !this.isTreated())
		{
			ret += " (Fresh)";
		}

		return ret;
	}
});

::Hardened.HooksMod.hookTree("scripts/skills/injury/injury", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.isFresh() && !this.isTreated())
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Was received on [Round|Concept.Round] " + ::MSU.Text.colorPositive(this.m.RoundAdded)),
			});
		}

		return ret;
	}
});
