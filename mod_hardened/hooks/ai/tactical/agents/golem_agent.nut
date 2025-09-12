::Hardened.HooksMod.hook("scripts/ai/tactical/agents/golem_agent", function(q) {
	q.onAddBehaviors = @(__original) { function onAddBehaviors()
	{
		__original();
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_break_free"));
	}}.onAddBehaviors;
});
