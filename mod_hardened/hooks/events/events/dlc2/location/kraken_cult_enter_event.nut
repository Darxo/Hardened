::Hardened.HooksMod.hook("scripts/events/events/dlc2/location/kraken_cult_enter_event", function(q) {
	q.onPrepare = @(__original) function()
	{
		__original();

		// Vanilla always wants you to find 3 more than you already have. We hard-set the amount of items you need to 3
		this.m.Dust = 3;
		this.m.Hides = 3;
	}
});
