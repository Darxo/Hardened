::Hardened.HooksMod.hook("scripts/items/trade/trading_good_item", function(q) {
// Hardened Functions
	q.getShopAmountMax = @(__original) function()
	{
		local ret = __original();

		if (::World.Retinue.hasFollower("follower.trader"))
		{
			ret += 1;
		}

		return ret;
	}
});
