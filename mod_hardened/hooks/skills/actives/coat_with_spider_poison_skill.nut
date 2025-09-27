::Hardened.HooksMod.hook("scripts/skills/actives/coat_with_spider_poison_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 7 && entry.icon == "ui/icons/special.png")
			{
				local poisonEffect = ::new("scripts/skills/effects/spider_poison_coat_effect");
				entry.text = ::Reforged.Mod.Tooltips.parseString("Coat your weapons in [Spider Poison|Skill+spider_poison_coat_effect]");
				entry.children <- poisonEffect.getTooltipWithoutChildren().slice(2);
			}
		}

		return ret;
	}
});
