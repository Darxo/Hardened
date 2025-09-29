::Hardened.HooksMod.hook("scripts/items/supplies/cured_rations_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;		// Vanilla: 150

		this.m.HD_MaxAmount = 50;	// Vanilla: 25
	}

// Hardened Functions
	// We dont want to have cured rations act as a pseudo-trade good with how long you can keep it with you,
	// so we make it so you can never sell it for profit
	q.getBaseSellPriceMult = @(__original)  function()
	{
		return ::Const.World.Assets.BaseSellPrice;
	}
});
