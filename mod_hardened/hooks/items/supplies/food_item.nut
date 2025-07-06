::Hardened.HooksMod.hook("scripts/items/supplies/food_item", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (!isDesirable())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Food is undesirable and will be eaten last",
			});
		}

		return ret;
	}

// Hardened Functions
	q.HD_getShelfLifeMult = @(__original) function()
	{
		// The value now only drops once the shelf life is below half
		return ::Math.minf(1.0, this.getSpoilInDays() * 2.0 / this.m.GoodForDays);
	}
});
