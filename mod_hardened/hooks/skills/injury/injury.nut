::Hardened.HooksMod.hook("scripts/skills/injury/injury", function(q) {
	// Private
	q.m.RoundAdded <- 0;

	q.onAdded = @(__original) function()
	{
		__original();
		if (this.getContainer().getActor().isPlacedOnMap())		// Todo find more general condition to check for whether its combat
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
