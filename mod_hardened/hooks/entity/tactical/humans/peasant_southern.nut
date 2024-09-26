::Hardened.HooksMod.hook("scripts/entity/tactical/humans/peasant_southern", function(q) {
// Hardened
	// This is called just before onDeath of this entity is called
	q.getDroppedLoot = @(__original) function( _killer, _skill, _fatalityType )
	{
		local roll = ::Math.rand(1, 100);
		if (roll == 1)	// Jackpot - one in a hundred for a big item
		{
			return [::new("scripts/items/loot/signet_ring_item")];	// 250 value
		}
		else if (roll <= 15)	// A few tools
		{
			local tools = ::new("scripts/items/supplies/armor_parts_item");
			tools.setAmount(::Math.rand(1, 2));		// 15-30 value
			return [tools];
		}
		else if (roll <= 40)	// A little food
		{
			local food = ::new(::MSU.Class.WeightedContainer([
				[1, "scripts/items/supplies/bread_item"],
				[1, "scripts/items/supplies/dates_item"],
				[1, "scripts/items/supplies/rice_item"],
				[1, "scripts/items/supplies/ground_grains_item"],
			]).roll());
			food.setAmount(::Math.rand(3, 8))	// 8 - 20 value
			return [food];
		}
		else	// Just some cash
		{
			local money = ::new("scripts/items/supplies/money_item");
			money.setAmount(::Math.rand(5, 15));
			return [money];
		}
	}
});
