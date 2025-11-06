::Hardened.HooksMod.hook("scripts/ai/tactical/agents/bounty_hunter_ranged_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.OverallDefensivenessMult = 1.5;	// Vanilla: 1.1
	}}.create;
});
