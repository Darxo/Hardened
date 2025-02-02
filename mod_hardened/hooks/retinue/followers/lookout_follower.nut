::Hardened.HooksMod.hook("scripts/retinue/followers/lookout_follower", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::MSU.String.replace(this.m.Description, " and will pay handsomely for any bounty fulfilled", "");
		this.m.Effects[0] = "Always receive a scouting report for enemies near you";	// This replaces the mention of sight radius
	}

	q.onUpdate = @(__original) function()
	{
		// Revert Vanilla change to VisionRadiusMult because that effect is removed from this follower
		local oldVisionRadiusMult = ::World.Assets.m.VisionRadiusMult;
		__original();
		::World.Assets.m.VisionRadiusMult = oldVisionRadiusMult;

		::World.Assets.m.IsAlwaysShowingScoutingReport = true;
	}
});
