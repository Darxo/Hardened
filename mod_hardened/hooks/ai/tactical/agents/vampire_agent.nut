::Hardened.HooksMod.hook("scripts/ai/tactical/agents/vampire_agent", function(q) {
	q.onAddBehaviors = @(__original) function()
	{
		__original();

		// Vanilla Fix: Remove EngageMelee behavior, so that vampires stop walking up to targest, wasting their mobility and turn in the process
		this.removeBehavior(::Const.AI.Behavior.ID.EngageMelee);
	}
});
