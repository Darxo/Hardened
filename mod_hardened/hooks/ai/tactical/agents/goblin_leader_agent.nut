::Hardened.HooksMod.hook("scripts/ai/tactical/agents/goblin_leader_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.OverallDefensivenessMult = 2.0;	// Vanilla: 1.0
	}}.create;
});
