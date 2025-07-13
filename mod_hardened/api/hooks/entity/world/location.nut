::Hardened.HooksMod.hook("scripts/entity/world/location", function(q) {
	q.m.HideDefenderAtNight <- true;	// Hide Defender Line up at night?
	q.m.HD_CanSpawnParties <- true;	// When false, this location will never be chosen for actions which spawn random world parties from it
	q.m.HD_MinPlayerDistanceForSpawn <- 0;	// If the player is hostile to this location then this many tiles must be between this location and the player for it to be able to spawn parties

	q.getLastSpawnTime = @(__original) function()
	{
		if (this.HD_canSpawnParties())
		{
			return __original();
		}
		else
		{
			// If this location is not supposed to spawn world parties, we pretend like its lastSpawnTime is always equal to ::Time.getVirtualTimeF()
			// This should cause most actions to ignore this locations for their actions
			return ::Time.getVirtualTimeF();
		}
	}

	// Locations no longer display defender during night, unless the player has Lookout follower or plays Poacher Scenario
	q.isShowingDefenders = @(__original) function()
	{
		local oldIsShowingDefenders = this.m.IsShowingDefenders;
		if (this.m.HideDefenderAtNight) this.m.IsShowingDefenders = this.m.IsShowingDefenders && ::World.getTime().IsDaytime;

		local ret = __original() || ::World.Assets.m.IsAlwaysShowingScoutingReport;

		this.m.IsShowingDefenders = oldIsShowingDefenders;

		return ret;
	}

// New Functions
	// Determines, whether this location is allowed to spawn parties
	q.HD_canSpawnParties <- function()
	{
		if (!this.m.HD_CanSpawnParties) return false;

		if (this.m.HD_MinPlayerDistanceForSpawn == 0) return true;
		if (::World.State.getPlayer().isAlliedWith(this)) return true;
		local playerTileDistance = ::World.State.getPlayer().getTile().getDistanceTo(this.getTile());
		return playerTileDistance >= this.m.HD_MinPlayerDistanceForSpawn;
	}
});
