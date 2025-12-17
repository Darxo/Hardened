// Overwrite to replace usage of getCost with getPredictedWorth
::DynamicSpawns.Class.UnitBlock.sort <- function()
{
	::DynamicSpawns.__stableSort(this.__DynamicSpawnables, @(a, b) a.getPredictedWorth() <=> b.getPredictedWorth());		// Hardened: We replace getCost with getPredictedWorth for a more accurate upgrade order
}
