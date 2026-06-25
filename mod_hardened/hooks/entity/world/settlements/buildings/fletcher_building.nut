::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/fletcher_building", function(q) {
	q.m.HD_PriceMult <- 1.25;	// Vanilla: 0.75

	q.getDefaultShopList = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.S == "weapons/throwing_spear")
			{
				// We reduce the rarity and increase price to make Throwing Spears on par with throwing nets that are also now sold here
				entry.R = 20;	// In Vanilla this is 90
				entry.P = 1.5;	// In Vanilla this is 1.0
			}
			else if (entry.S == "tools/throwing_net")
			{
				entry.P = 2.0;	// In Reforged this is 3.0
			}
		}

		// We add throwing spears a second time similar to how nets have two entries
		ret.push({
			R = 20,
			P = 1.5,
			S = "weapons/throwing_spear",
		});

		return ret;
	}
});
