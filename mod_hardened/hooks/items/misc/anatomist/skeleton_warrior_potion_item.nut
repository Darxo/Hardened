::Hardened.HooksMod.hook("scripts/items/misc/anatomist/skeleton_warrior_potion_item", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("[Shieldwall|Skill+shieldwall] costs " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]");
			}
		}

		return ret;
	}
});
