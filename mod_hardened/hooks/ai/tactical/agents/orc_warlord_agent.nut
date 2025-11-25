::Hardened.HooksMod.hook("scripts/ai/tactical/agents/bandit_ranged_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.EngageFlankingMult = 0.5;	// Vanilla: 1.0
	}}.create;
});
