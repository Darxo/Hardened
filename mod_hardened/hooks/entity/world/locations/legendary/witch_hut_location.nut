::Hardened.HooksMod.hook("scripts/entity/world/locations/legendary/witch_hut_location", function(q) {
	q.onDropLootForPlayer = @(__original) function (_lootTable)
	{
		__original(_lootTable);

		// Feat: The legendary witch hut location now also drops the two buff potions that you normally only get from a contract twist
		_lootTable.push(::new("scripts/items/special/bodily_reward_item"));
		_lootTable.push(::new("scripts/items/special/spiritual_reward_item"));
	}
});
