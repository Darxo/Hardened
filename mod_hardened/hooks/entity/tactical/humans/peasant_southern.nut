::Hardened.HooksMod.hook("scripts/entity/tactical/humans/peasant_southern", function(q) {
	// Public
	q.m.FoodDropTable <- ::MSU.Class.WeightedContainer([
		[1, "scripts/items/supplies/bread_item"],
		[1, "scripts/items/supplies/dates_item"],
		[1, "scripts/items/supplies/rice_item"],
		[1, "scripts/items/supplies/ground_grains_item"],
	]);

	q.getLootForTile = @(__original) function( _killer, _loot )
	{
		local ret = __original(_killer, _loot);

		if (this.isLootAssignedToPlayer(_killer))
		{
			local roll = ::Math.rand(1, 100);
			if (roll == 1)	// Jackpot - one in a hundred for a big item
			{
				ret.push(::new("scripts/items/loot/signet_ring_item"));	// 250 value
			}
			else if (roll <= 15)	// A few tools
			{
				local tools = ::new("scripts/items/supplies/armor_parts_item");
				tools.setAmount(::Math.rand(1, 2));
				ret.push(tools);
			}
			else if (roll <= 40)	// A little food
			{
				local food = ::new(this.m.FoodDropTable.roll());
				food.setAmount(::Math.rand(5, 10))
				ret.push(food);
			}
			else	// Just some cash
			{
				local money = ::new("scripts/items/supplies/money_item");
				money.setAmount(::Math.rand(10, 20));
				ret.push(money);
			}
		}

		return ret;
	}
});
