// We reduce the IdealSize multiplier for locations as 50% was too much and was upgrading their troops too late
::DynamicSpawns.Class.Party.IdealSizeLocationMult <- 1.3;	// Dynamic Spawns: 1.5

// Overwrite to make it so HardMin on unitblocks causes a force spawn on them
::DynamicSpawns.Class.Party.prepareAffordables <- function( _spawn, _upgrade )
{
	this.__SpawnAffordables.clear();
	this.__UpgradeAffordables.clear();
	this.__ForcedSpawnable = null;

	foreach (spawnable in this.__DynamicSpawnables)
	{
		if (_spawn && spawnable.canSpawn())
		{
			// Hardened: Start: We also check for getHardMin to guarantee block with that property to force spawn
			if (spawnable.satisfiesRatioMin() == false || spawnable.getHardMin() > spawnable.getSpawnedUnits().len())
			{
				// We want to force a spawn that is below its RatioMin or which is below its HardMin
				this.__ForcedSpawnable = spawnable;
				return; 	// Early return for performance as we found a force-spawn
			}
			// Hardened: End
			local weight = spawnable.getSpawnWeight();
			if (weight != 0)
				this.__SpawnAffordables.add(spawnable, weight);
		}

		if (_upgrade && spawnable.canUpgrade())
		{
			local weight = spawnable.getUpgradeWeight();
			if (weight != 0)
				this.__UpgradeAffordables.add(spawnable, weight);
		}
	}
}

// Overwrite to replace usage of getCost with getMinCost
::DynamicSpawns.Class.Party.getFigure <- function()
{
	local getUnitsWithFigure;
	getUnitsWithFigure = function( _spawnable )
	{
		local units = [];
		local spawnables = clone _spawnable.__DynamicSpawnables;
		spawnables.extend(_spawnable.__StaticSpawnables);
		foreach (s in spawnables)
		{
			if (!s.determinesFigure())
				continue;

			if (s instanceof ::DynamicSpawns.Class.Unit)
			{
				if (s.getFigure() != "" && s.getTotal() != 0)
					units.push(s);
			}
			else
				units.extend(getUnitsWithFigure(s));
		}
		return units;
	}

	local units = getUnitsWithFigure(this);
	if (units.len() != 0)
	{
		units.sort(@(a, b) a.getMinCost() <=> b.getMinCost());	// Hardened: We replace getCost with getMinCost for a more accurate figure
		return units.top().getFigure();
	}

	local ret = typeof this.DefaultFigure == "array" ? this.DefaultFigure[::Math.rand(0, this.DefaultFigure.len() - 1)] : this.DefaultFigure;
	if (ret == "")
		::logError(format("Provide a DefaultFigure for this party (%s) or make sure Spawnables with DeterminesFigure actually spawn units with a defined Figure", this.getLogName()));

	return ret;
}

// Implement getMinCost for party
// Return the cost of this party, if it was spawned with 0 available resources
// As a result only static spawnables and those, forced with HardMin > 0 will spawn and contribute to the MinCost
// The same call might still result in varying results, if a bodyguard definition uses a HardMin but randomized unitblock
::DynamicSpawns.Class.Party.getMinCost <- function()
{
	local wasLogging = ::DynamicSpawns.Const.Logging
	::DynamicSpawns.Const.Logging = false;
	local ret = (clone this).init().spawn(0).getWorth();
	::DynamicSpawns.Const.Logging = wasLogging;
	return ret;
}
