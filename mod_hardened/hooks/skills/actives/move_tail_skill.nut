::Hardened.HooksMod.hook("scripts/skills/actives/move_tail_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Follow your head wherever it goes!";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/special.png")	// Reforged currently still displays this tooltip even if the bonus is 0
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Move next to your head ignoring [zone of control|Concept.ZoneOfControl]");
				break;
			}
		}

		return ret;
	}
});
