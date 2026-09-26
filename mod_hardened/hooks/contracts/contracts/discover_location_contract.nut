// Adjustments
// 1. Serialize LastHelpTime
//	- Loading the game no longer instantly spawns a direction-helping dialog
// 2. Cached direction information
//	- Loading the game no longer updates your bullet point to the pin-point accurate location of the targeted location

::Hardened.HooksMod.hook("scripts/contracts/contracts/discover_location_contract", function(q) {
	// Private
	q.m.CachedInformation <- null;	// Will later contain a table with 4 cached direction information

	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "SurprisingHelpAltruists")
			{
				foreach (option in screen.Options)
				{
					if (option.Text != "Much appreciated.") continue;

					local oldGetResult = option.getResult;
					option.getResult = function()
					{
						this.Contract.cacheInformation();
						this.Contract.getActiveState().start();	// Only after calling the start() function of a state, will the UI be updated to show the new directions
						::World.Contracts.updateActiveContract();	// For some reason this is not needed during deserialization
						return oldGetResult();
					}
				}
			}
			else if (screen.ID == "SurprisingHelpOpportunists2")
			{
				foreach (option in screen.Options)
				{
					if (option.Text != "Got it.") continue;

					local oldGetResult = option.getResult;
					option.getResult = function()
					{
						this.Contract.cacheInformation();
						this.Contract.getActiveState().start();	// Only after calling the start() function of a state, will the UI be updated to show the new directions
						::World.Contracts.updateActiveContract();
						return oldGetResult();
					}
				}
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
					this.Contract.cacheInformation();	// We cache the destination directions right after the player accepts this contract
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
						// We overwrite the vanilla bulletpoints with cached values, to prevent cheese, where the player loads a game to get up to date information about the target
						this.Contract.m.BulletpointsObjectives[0] = format("Find %s %s to the %s and somewhere around the region of %s", cache.Location, cache.Distance, cache.Direction, cache.Region);
					}
				}
			}

		}
	}

	q.onSerialize = @(__original) function( _out )
	{
		if (this.m.CachedInformation != null)
		{
			this.m.Flags.set("HD_CachedLocation", this.m.CachedInformation.Location);
			this.m.Flags.set("HD_CachedDistance", this.m.CachedInformation.Distance);
			this.m.Flags.set("HD_CachedDirection", this.m.CachedInformation.Direction);
			this.m.Flags.set("HD_CachedRegion", this.m.CachedInformation.Region);
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
				Location = this.m.Flags.get("HD_CachedLocation"),
				Distance = this.m.Flags.get("HD_CachedDistance"),
				Direction = this.m.Flags.get("HD_CachedDirection"),
				Region = this.m.Flags.get("HD_CachedRegion")
			};

			local activeState = this.getActiveState();
			if (activeState != null && activeState.ID == "Running")
			{
				activeState.start();	// Only after calling the start() function of a state, will the UI be updated to show the new directions
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
			if (variable[0] == "location") this.m.CachedInformation.Location <- variable[1];
			if (variable[0] == "distance") this.m.CachedInformation.Distance <- variable[1];
			if (variable[0] == "direction") this.m.CachedInformation.Direction <- variable[1];
			if (variable[0] == "region") this.m.CachedInformation.Region <- variable[1];
		}
	}
});
