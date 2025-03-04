::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_vigorous_assault", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/fatigue.png")
			{
				entry.text = ::MSU.String.replace(entry.text, "builds up", "costs");
			}
			else if (entry.id == 20 && entry.icon == "ui/icons/warning.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Will expire upon using any skill, [waiting|Concept.Wait] or ending your [turn,|Concept.Turn]");
			}
		}

		return ret;
	}

	// Overwrite because swapping weapons no longer disables this perks effect
	q.onPayForItemAction = @() function( _skill, _items ) {}
});
