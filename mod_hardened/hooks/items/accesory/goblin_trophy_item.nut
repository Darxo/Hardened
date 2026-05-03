::Hardened.HooksMod.hook("scripts/items/accessory/goblin_trophy_item", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Immune to [Displacement|Concept.Displacement]");
			}
		}

		return ret;
	}
});
