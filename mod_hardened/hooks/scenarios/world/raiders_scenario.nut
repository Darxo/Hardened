::Hardened.HooksMod.hook("scripts/scenarios/world/raiders_scenario", function(q) {
	q.onSpawnAssets = @(__original) function()
	{
		__original();

		::World.Assets.m.BusinessReputation = -100;	// Vanilla: -50
	}
});
