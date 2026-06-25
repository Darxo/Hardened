::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/weaponsmith_oriental_building", function(q) {
	q.getDefaultShopList = @(__original) function()
	{
		local ret = __original();

		ret.push({
			R = 0,
			P = 1.25,	// Note that these buildings have an inherent price multiplier of 1.25
			S = "supplies/armor_parts_item",
		});

		return ret;
	}
});
