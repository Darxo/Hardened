// Overwrite to replace usage of getCost with getMinCost
::DynamicSpawns.Class.UnitBlock.sort <- function()
{
	this.__DynamicSpawnables.sort(@(a, b) a.getMinCost() <=> b.getMinCost());		// Hardened: We replace getCost with getMinCost for a more accurate upgrade order
}

// Overwrite to replace usage of getCost with getMinCost
::DynamicSpawns.Class.UnitBlock.chooseUnitForUpgrade <- function()
{
	local choices = ::MSU.Class.WeightedContainer();

	local tiers = 0;
	// Ignore the highest tier
	for (local i = 0; i < this.__DynamicSpawnables.len() - 1 && tiers < this.TierWidth - 1; i++)
	{
		local unit = this.__DynamicSpawnables[i];
		local count = unit.getTotal();
		if (count > 0)
		{
			tiers++;
			for (local j = i + 1; j < this.__DynamicSpawnables.len(); j++)	// for loop because the next very unitType could have some requirements (like playerstrength) preventing spawn
			{
				if (this.__DynamicSpawnables[j].canSpawn(unit.getMinCost()))	// Hardened: We replace getCost with getMinCost for a more accurate upgrade order
				{
					choices.add({Unit = unit, UpgradeUnit = this.__DynamicSpawnables[j]}, unit.getUpgradeWeight());
					break;	// We are only interested in the closest possible upgrade path, not all of them
				}
			}
		}
	}

	return choices.roll();
}
