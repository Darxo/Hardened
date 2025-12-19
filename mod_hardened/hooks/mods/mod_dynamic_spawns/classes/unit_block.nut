// All UnitBlocks now have a TierWidth of 2 by default, causing them to only spawn at most 2 tiers at the same time
// Some blocks might not properly spawn all units then (e.g. Ghouls), but we deal with those on a case by case basis
::DynamicSpawns.Class.UnitBlock.TierWidth <- 2;	// Reforged: 9999

// Overwrite to replace usage of getCost with getPredictedWorth
::DynamicSpawns.Class.UnitBlock.sort <- function()
{
	::DynamicSpawns.__stableSort(this.__DynamicSpawnables, @(a, b) a.getPredictedWorth() <=> b.getPredictedWorth());		// Hardened: We replace getCost with getPredictedWorth for a more accurate upgrade order
}

