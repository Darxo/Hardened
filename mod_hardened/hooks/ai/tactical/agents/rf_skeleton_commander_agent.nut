::Hardened.HooksMod.hook("scripts/ai/tactical/agents/rf_skeleton_commander_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Properties.PreferWait = true;	// We turn this on, so that skeleton commanders move more safely across the battlefield
	}}.create;
});
