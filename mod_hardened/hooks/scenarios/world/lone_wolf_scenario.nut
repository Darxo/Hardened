::Hardened.HooksMod.hook("scripts/scenarios/world/lone_wolf_scenario", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::MSU.String.replace(this.m.Description, "12", "13");
	}

	q.onSpawnAssets = @(__original) function()
	{
		__original();

		::World.Assets.m.BusinessReputation = 100;	// Vanilla: 200
	}

	q.onInit = @(__original) function()
	{
		__original();
		// We raise the maximum brothers for lone wolf so that you can have a much easier time refining the 12th core slot
		if (::World.Assets.m.BrothersMax == 12) ::World.Assets.m.BrothersMax = 13;	// Vanilla: 12
	}
});
