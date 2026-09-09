::Hardened.HooksMod.hook("scripts/ambitions/ambitions/allied_civilians_ambition", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.RewardTooltip = "";	// Remove the bloated vanilla fluff text about better prices
	}}.create;
});
