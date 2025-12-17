// Overwrite to replace usage of getCost with getMinCost
::DynamicSpawns.Class.UnitBlock.sort <- function()
{
	this.__DynamicSpawnables.sort(@(a, b) a.getMinCost() <=> b.getMinCost());		// Hardened: We replace getCost with getMinCost for a more accurate upgrade order
}
