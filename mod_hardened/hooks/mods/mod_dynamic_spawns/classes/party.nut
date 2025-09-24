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

