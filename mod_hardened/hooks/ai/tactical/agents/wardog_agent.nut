::Hardened.HooksMod.hook("scripts/ai/tactical/agents/wardog_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();

		// We make wardog avoid engaging multiple enemies at once
		this.m.Properties.EngageTargetMultipleOpponentsMult = 2.0;	// Vanilla: 0.0
	}}.create;
});
