::Hardened.HooksMod.hook("scripts/scenarios/world/tutorial_scenario", function(q) {
	q.onSpawnAssets = @(__original) function()
	{
		__original();

		::World.Assets.m.BusinessReputation = 0;	// Vanilla: 100
	}
});
