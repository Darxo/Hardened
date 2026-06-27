::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/marketplace_oriental_building", function(q) {
	q.getDefaultShopList = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.S == "accessory/wardog_item")
			{
				entry.R = 95;	// Reforged: 70
			}
			else if (entry.S == "accessory/armored_wardog_item")
			{
				entry.R = 99;	// Reforged: 80
			}
		}

		if (this.getSettlement().getSize() <= 2 && !this.getSettlement().isMilitary())
		{
			// Add lute to lower tier settlements
			ret.push({
				R = 90,
				P = 1.0,
				S = "weapons/lute",
			});
		}

		return ret;
	}
});
