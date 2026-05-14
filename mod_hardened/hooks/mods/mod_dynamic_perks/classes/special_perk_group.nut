::Hardened.HooksMod.hook(::DynamicPerks.Class.SpecialPerkGroup, function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local childrenElements = [];
		if ("getSelfMultiplier" in this)
		{
			childrenElements.push({
				id = 40,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Affected by additional conditions",
			});
		}

		if ("getPerkGroupMultiplier" in this)
		{
			childrenElements.push({
				id = 41,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Affected by rolled perks",
			});
		}

		ret.push({
			id = 10,
			type = "hint",
			icon = "ui/icons/special.png",
			text = "Base Chance: " + ::MSU.Text.colorPositive(this.getChance() + "%"),
			children = childrenElements,
		});

		return ret;
	}
});
