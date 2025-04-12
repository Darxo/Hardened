// Adjustments
// 1. Serialize LastHelpTime
//	- Loading the game no longer instantly spawns a direction-helping dialog
// 2. Cached direction information
//	- Loading the game no longer updates your bullet point to the pin-point accurate location of the king

::Hardened.HooksMod.hook("scripts/contracts/contracts/barbarian_king_contract", function(q) {
	// Private
	q.m.CachedInformation <- null;	// Will later contain a table with 4 cached direction information

	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (screen.ID != "Directions") continue;

			local oldStart = screen.start;
			screen.start = function()
			{
				oldStart();

				this.Contract.cacheInformation();
			}
		}
	}

	q.createStates = @(__original) function()
	{
		__original();
		foreach (state in this.m.States)
		{
			if (state.ID == "Offer")
			{
				local oldEnd = state.end;
				state.end = function()
				{
					oldEnd();
					this.Contract.cacheInformation();	// We cache the barbarian king directions right after the player accepts this contract
				}
			}
			else if (state.ID == "Running")
			{
				local oldStart = state.start;
				state.start = function()
				{
					oldStart();
					local cache = this.Contract.m.CachedInformation;
					if (cache != null)
					{
						// We overwrite the vanilla bulletpoints with cached values, to prevent cheese, where the player loads a game to get up to date information about the king
						this.Contract.m.BulletpointsObjectives[1] = format("His warhost was last spotted around %s, %s %s from you, near %s", cache.Region, cache.Terrain, cache.Direction, cache.NearestTown);
					}
				}
			}

		}
	}

	q.onSerialize = @(__original) function( _out )
	{
		if (this.m.CachedInformation != null)
		{
			this.m.Flags.set("HD_CachedRegion", this.m.CachedInformation.Region);
			this.m.Flags.set("HD_CachedTerrain", this.m.CachedInformation.Terrain);
			this.m.Flags.set("HD_CachedDirection", this.m.CachedInformation.Direction);
			this.m.Flags.set("HD_CachedNearestTown", this.m.CachedInformation.NearestTown);
		}

		this.m.Flags.set("HD_LastHelpTime", this.m.LastHelpTime);

		__original(_out);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		if (this.m.Flags.has("HD_CachedRegion"))
		{
			this.m.CachedInformation = {
				Region = this.m.Flags.get("HD_CachedRegion"),
				Terrain = this.m.Flags.get("HD_CachedTerrain"),
				Direction = this.m.Flags.get("HD_CachedDirection"),
				NearestTown = this.m.Flags.get("HD_CachedNearestTown")
			};

			local activeState = this.getActiveState();
			if (activeState != null && activeState.ID == "Running")
			{
				local cache = this.m.CachedInformation;
				this.m.BulletpointsObjectives[1] = format("His warhost was last spotted around %s, %s %s from you, near %s", cache.Region, cache.Terrain, cache.Direction, cache.NearestTown);
			}
		}

		if (this.m.Flags.has("HD_LastHelpTime"))
		{
			this.m.LastHelpTime = this.m.Flags.get("HD_LastHelpTime");
		}
	}

// New Functions
	// Cache the information relevant for the bullet points, provided by this contracts onPrepareVariables
	q.cacheInformation <- function()
	{
		this.m.CachedInformation = {};

		local vars = [];
		this.onPrepareVariables(vars);
		foreach (variable in vars)
		{
			if (variable[0] == "region") this.m.CachedInformation.Region <- variable[1];
			if (variable[0] == "terrain") this.m.CachedInformation.Terrain <- variable[1];
			if (variable[0] == "direction") this.m.CachedInformation.Direction <- variable[1];
			if (variable[0] == "nearest_town") this.m.CachedInformation.NearestTown <- variable[1];
		}
	}
});
