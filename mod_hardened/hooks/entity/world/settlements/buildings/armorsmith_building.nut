::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/armorsmith_building", function(q) {
	q.getDefaultShopList = @(__original) function()
	{
		local ret = __original();

		local shieldSpawnChance = 400 / ::Const.Items.NamedShields.len();	// We choose the chance so that 4 shields are chosen on average
		foreach (namedShield in ::Const.Items.NamedShields)
		{
			if (::Math.rand(1, 100) <= shieldSpawnChance)
			{
				ret.push({
					R = 99,		// Same rarity as other named gear
					P = 3.0,	// Other named gear has 2.0 here, but shields have a much smaller base price
					S = namedShield,
				});
			}
		}

		ret.push({
			R = 0,
			P = 1.25,	// Note that these buildings have an inherent price multiplier of 1.25
			S = "supplies/armor_parts_item",
		});

		return ret;
	}
});
