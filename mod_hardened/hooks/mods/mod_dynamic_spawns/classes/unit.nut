// Implement getMinCost for units
::DynamicSpawns.Class.Unit.getMinCost <- function()
{
	local ret = this.getCost();
	if (__StaticSpawnables != null)
	{
		foreach (spawnable in this.__StaticSpawnables)
		{
			ret += spawnable.getMinCost();
		}
	}
	return ret;
}

// Overwrite to replace usage of getCost with getMinCost
::DynamicSpawns.Class.Unit.getUpgradeWeight <- function()
{
	local ret = this.getTotal();
	if (this.__ParentSpawnable != null)
		ret += 3 * (this.__ParentSpawnable.__DynamicSpawnables.len() - 1 - this.__ParentSpawnable.__DynamicSpawnables.find(this));
	return ret * (1.0 / ::Math.pow(this.getMinCost(), 2));	// Hardened: We replace getCost with getMinCost for a more accurate upgrade weight
}
