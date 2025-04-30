::Hardened.HooksMod.hook("scripts/items/misc/paint_set_item", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::Reforged.Mod.Tooltips.parseString("Shields in any mercenary color grant " + ::MSU.Text.colorPositive("+5") + " [Resolve|Concept.Bravery] when equipped"),
		});

		return ret;
	}
});
