::Hardened.HooksMod.hook("scripts/ai/tactical/agents/goblin_ranged_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.TargetPriorityHitchanceMult = 1.0;		// Vanilla: 0.6
		// Goblins work with poison damage, so they prefer hitting enemies whose armor they can pierce
		this.m.Properties.TargetPriorityHitpointsMult = 0.50;		// Vanilla: 0.15
		this.m.Properties.TargetPriorityFinishOpponentMult = 2.0;	// Vanilla: 3.0

		this.m.Properties.OverallDefensivenessMult = 1.5;	// Vanilla: 1.15
	}}.create;
});
