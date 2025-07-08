::Hardened.HooksMod.hook("scripts/items/trade/trading_good_item", function(q) {
	// We implement BuyPriceTradeMult and BuyPriceNotLocalCulture handling here
	// In Vanilla those happen in the getBuyPrice function but that one is overwritten in Hardened
	q.getBuyPriceMult = @(__original) function()
	{
		local ret = __original();

		ret *= ::World.Assets.m.BuyPriceTradeMult;

		local currentTown = ::World.State.getCurrentTown();

		// If a trade good is not local, it will be more expensive to buy
		local isLocalCulture = false;
		if (this.m.Culture == ::Const.World.Culture.Neutral) isLocalCulture = true;		// Items with neutral culture are local to any town
		if (currentTown.getCulture() == this.m.Culture) isLocalCulture = true;			// Items with the same culture as the current town are local
		if (currentTown.hasBuilding("building.port")) isLocalCulture = true;			// All wares are local to Towns with Ports
		if (!isLocalCulture) ret *= ::Const.World.Assets.BuyPriceNotLocalCulture;

		return ret;
	}

	// We implement SellPriceTradeMult and SellPriceNotLocalCulture handling here
	// In Vanilla those happen in the getSellPrice function but that one is overwritten in Hardened
	q.getSellPriceMult = @(__original) function()
	{
		local ret = __original();

		ret *= ::World.Assets.m.SellPriceTradeMult;

		local currentTown = ::World.State.getCurrentTown();

		// If a trade good is not local, it will be more expensive to buy
		local isLocalCulture = false;
		if (this.m.Culture == ::Const.World.Culture.Neutral) isLocalCulture = true;		// Items with neutral culture are local to any town
		if (currentTown.getCulture() == this.m.Culture) isLocalCulture = true;			// Items with the same culture as the current town are local
		if (currentTown.hasBuilding("building.port")) isLocalCulture = true;			// All wares are local to Towns with Ports
		if (!isLocalCulture) ret *= ::Const.World.Assets.SellPriceNotLocalCulture;

		return ret;
	}

// Hardened Functions
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
