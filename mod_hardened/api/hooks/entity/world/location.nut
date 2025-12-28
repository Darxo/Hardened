::Hardened.HooksMod.hook("scripts/entity/world/location", function(q) {
	q.m.HideDefenderAtNight <- true;	// Hide Defender Line up at night?
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

	// We disable the vanilla defender day scaling and instead apply it via ::Hardened.Global.getWorldDifficultyMult()
	q.createDefenders = @(__original) function()
	{
		if (!this.m.IsScalingDefenders) return __original();

		// Switcheroo of this.m.Resources to apply our new global difficulty multiplier in a dynamic way
		local oldResources = this.m.Resources;
		this.m.Resources *= ::Hardened.Global.getWorldDifficultyMult();

		// We turn off IsScalingDefenders to disable the vanilla day-scaling
		this.m.IsScalingDefenders = false;
		local ret =  __original();
		this.m.IsScalingDefenders = true;	// We know that IsScalingDefender was not false before, so we can always set it to true

		this.m.Resources = oldResources;

		return ret;
	}

// New Functions
	// Determines, whether this location is allowed to spawn parties
	q.HD_canSpawnParties <- function()
	{
		if (this.m.HD_MinPlayerDistanceForSpawn == 0) return true;
		if (::World.State.getPlayer().isAlliedWith(this)) return true;
		local playerTileDistance = ::World.State.getPlayer().getTile().getDistanceTo(this.getTile());
		return playerTileDistance >= this.m.HD_MinPlayerDistanceForSpawn;
	}
});
