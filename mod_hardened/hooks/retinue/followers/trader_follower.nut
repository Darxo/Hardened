::Hardened.HooksMod.hook("scripts/retinue/followers/trader_follower", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[0] = "+1 maximum amount of each type of Trade Goods for sale";	// This effect is rewritten to be more consize and accurate
		this.m.Effects.insert(0, "Trade Goods are 100% more common in shops");	// This effect is new and it's implemented in trading_good_item
	}
});
