::Hardened.HooksMod.hook("scripts/ai/tactical/agents/goblin_ranged_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.OverallDefensivenessMult = 1.5;	// Vanilla: 1.15
	}}.create;
});
