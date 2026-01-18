::Hardened.HooksMod.hook("scripts/ai/tactical/agents/militia_ranged_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.TargetPriorityHitchanceMult = 1.5;		// Vanilla: 0.75
		this.m.Properties.TargetPriorityFinishOpponentMult = 1.5;	// Vanilla: 3.0
	}}.create;
});
