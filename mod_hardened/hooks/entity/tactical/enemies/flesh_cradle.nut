::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/flesh_cradle", function(q) {
// Reforged Functions
	q.getLootForTile = @(__original) function( _killer, _loot )
	{
		local ret = __original(_killer, _loot);

		if (this.RF_canDropLootForPlayer(_killer))
		{
			ret.push(::new("scripts/items/supplies/strange_meat_item"));
		}

		return ret;
	}
});
