::Hardened.HooksMod.hook("scripts/skills/traits/iron_jaw_trait", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(1.25) + " resistant to receiving [Injuries|Concept.Injury]");
			}
		}

		return ret;
	}
});
