::Hardened.HooksMod.hook("scripts/ai/tactical/agents/goblin_melee_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.PreferCarefulEngage = true;
	}}.create;
});

