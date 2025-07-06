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

	q.getRarityMult = @(__original) function( _settlement = null )
	{
		local ret = __original(_settlement);

		if (::World.Retinue.hasFollower("follower.trader"))
		{
			ret *= 2.0;		// The Trader Retinue now makes trade goods 100% more likely to appear
		}

		return ret;
	}
});
