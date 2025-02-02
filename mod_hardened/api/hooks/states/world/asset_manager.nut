::Hardened.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.m.IsAlwaysShowingScoutingReport <- false;		// Same effect as Vanilla Poacher Origin

	q.resetToDefaults = @(__original) function()
	{
		this.m.IsAlwaysShowingScoutingReport = false;
		__original();
	}
