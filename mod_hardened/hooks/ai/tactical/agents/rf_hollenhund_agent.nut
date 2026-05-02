::Hardened.HooksMod.hook("scripts/ai/tactical/agents/rf_hollenhund_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.EngageFlankingMult = 5.0;		// Reforged: 2.0
	}}.create;
});
