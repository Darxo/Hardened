::Hardened.HooksMod.hook("scripts/factions/faction_manager", function(q) {
	q.runSimulation = @(__original) function()
	{
		__original();
		this.buildExtraLocations();
	}

// New Functions
	q.buildExtraLocations <- function()
	{
		local maxCycles = 100;
		local maxTriesPerCycle = 10;
		local expectedBanditLocations = 15;	// We try to have this many bandit location present at start. In vanilla 10 is the value they aim for
		local dummyAction = ::new("scripts/factions/faction_action");	// This class has two helper functions, which we need and don't want to reimplement
		dummyAction.m.Faction = this.getFactionOfType(::Const.FactionType.Bandits);

		// Spawn additional bandit locations if the initial Simulation couldn't produce enough
		local numberOfCamps = expectedBanditLocations - dummyAction.m.Faction.getSettlements().len();

		local campsCreated = 0;
		local currentCycle = 1;
		for (; currentCycle <= maxCycles; ++currentCycle)
		{
			if (this.tryBuildBanditLocation(maxTriesPerCycle, dummyAction))
			{
				++campsCreated;
				if (campsCreated >= numberOfCamps) break;
			}
			::__ping();		// Tell the backend that the game has not frozen up
		}

		::logInfo("Hardened: " + campsCreated + "/" + numberOfCamps + " additional bandit hideouts were placed after Simulation after " + currentCycle + "/" + maxCycles + " cycles.");
	}

	// Tries to find a location to spawn a bandit camp in for _maxTries times and then create the camp in it
	// Return true if it was successful
	q.tryBuildBanditLocation <- function( _maxTries, _dummyAction )
	{
		local faction = this.getFactionOfType(::Const.FactionType.Bandits);
		local minDistToSettlements = 7;		// In Vanilla this is 6, but was treated as 7 anyways, because of minDistToEnemies
		local maxDistToSettlements = 18;	// In Vanilla this is 12

		// We want those locations to be really spaced out and fill out the remaining land
		local minDistToEnemies = 7;	// In Vanilla this is 7, because we want to maintain a close possible distance to towns
		local minDistToAllies = 11;	// In Vanilla this is 7
		local minY = 0.2;
		local maxY = 0.75;

		local tile = _dummyAction.getTileToSpawnLocation(
			_maxTries,
			[
				::Const.World.TerrainType.Mountains,
				::Const.World.TerrainType.Snow,
			],
			minDistToSettlements,
			maxDistToSettlements,
			1000,	// The vanilla function looks like it can't deal properly with values other than 1000 and will softlock
			minDistToEnemies,
			minDistToAllies,
			null,
			minY,
			maxY
		);
		if (tile == null) return false;

		local camp = ::World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords);
		if (camp == null) return false;

		local banner = _dummyAction.getAppropriateBanner(camp, _dummyAction.m.Faction.getSettlements(), 15, ::Const.BanditBanners);
		camp.onSpawned();
		camp.setBanner(banner);
		_dummyAction.m.Faction.addSettlement(camp, false);

		return true;
	}
});
