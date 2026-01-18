::Hardened.HooksMod.hook("scripts/ai/tactical/agents/golem_agent", function(q) {
	q.onAddBehaviors = @(__original) { function onAddBehaviors()
	{
		__original();
		this.m.Properties.TargetPriorityHitchanceMult = 1.0;		// Vanilla: 0.5
		this.m.Properties.TargetPriorityFinishOpponentMult = 2.0;	// Vanilla: 3.0

		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_break_free"));
	}}.onAddBehaviors;
});
