::Hardened.HooksMod.hook("scripts/entity/world/location", function(q) {
	q.m.HideDefenderAtNight <- true;	// Hide Defender Line up at night?

	// Locations no longer display defender during night, unless the player has Lookout follower or plays Poacher Scenario
	q.isShowingDefenders = @(__original) function()
	{
		local oldIsShowingDefenders = this.m.IsShowingDefenders;
		if (this.m.HideDefenderAtNight) this.m.IsShowingDefenders = this.m.IsShowingDefenders && ::World.getTime().IsDaytime;

		local ret = __original();

		this.m.IsShowingDefenders = oldIsShowingDefenders;

		return ret;
	}
});
