::Hardened.HooksMod.hook("scripts/retinue/followers/negotiator_follower", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Cost = 2500;		// Vanilla: 3000
		this.m.Effects = [
			"Successful negotiations grant double bonus payment",
			"Bad Relations recover 100% faster",
			"Good Relations decay 15% slower",
		];
	}

	// Overwrite, because we change too many values
	q.onUpdate = @() function()
	{
		// ::World.Assets.m.HD_NegotiationPaymentMult = 0.5;
		// ::World.Assets.m.AdvancePaymentCap = 0.75;
		::World.Assets.m.HD_NegotiationPaymentMult = 2.0;
		::World.Assets.m.RelationDecayGoodMult = 0.85;		// Vanilla: 0.85
		::World.Assets.m.RelationDecayBadMult = 2.0;		// Vanilla: 1.15
	}
});
