::Hardened.HooksMod.hook("scripts/items/trade/trading_good_item", function(q) {
// Hardened Functions
	q.getBaseBuyPriceMult = @(__original) function()
	{
		if (this.isBuildingPresent(::World.State.getCurrentTown()))
		{
			return __original();
		}
		else
		{
			return ::Const.World.Assets.BuyPriceNotProducedHere;
		}
	}

	q.getBaseSellPriceMult = @(__original) function()
	{
		if (this.isBuildingPresent(::World.State.getCurrentTown()))
		{
			return __original();
		}
		else
		{
			return ::Const.World.Assets.SellPriceNotProducedHere;
		}
	}

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
