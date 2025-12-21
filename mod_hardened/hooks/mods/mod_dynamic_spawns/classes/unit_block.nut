// Feat: We prevent any upgrading, if IdealSize is not yet reached
local oldCanUpgrade = ::DynamicSpawns.Class.UnitBlock.canUpgrade;
::DynamicSpawns.Class.UnitBlock.canUpgrade <- function()
{
	local myParty = this.getTopParty();
	if (myParty.generateIdealSize() > myParty.getTotal()) return false;

	return oldCanUpgrade();
}

// All UnitBlocks now have a TierWidth of 2 by default, causing them to only spawn at most 2 tiers at the same time
// Some blocks might not properly spawn all units then (e.g. Ghouls), but we deal with those on a case by case basis
::DynamicSpawns.Class.UnitBlock.TierWidth <- 2;	// Reforged: 9999

// Overwrite to replace usage of getCost with getPredictedWorth
::DynamicSpawns.Class.UnitBlock.sort <- function()
{
	::DynamicSpawns.__stableSort(this.__DynamicSpawnables, @(a, b) a.getPredictedWorth() <=> b.getPredictedWorth());		// Hardened: We replace getCost with getPredictedWorth for a more accurate upgrade order
}

// Introduce new function for getting the startingResources cost of a spawnable
// This function is meant to be used for determining whether a unit can spawn and how to sort units inside of UnitBlocks (if those units have bodyguards)
::DynamicSpawns.Class.UnitBlock.getStartingResources <- function()
{
	return 0;
}

// We overwrite the Reforged "satisfiesTierWidth" in a very hacky way, to ensure that only the lowest present tier of unit is considered for spawning
// This currently works, because that function is only used in a single place, when considering which unit to spawn
// We make use of the fact, that this function is called in a for loop on all applicable spawnables, starting with the lowest one, and stopping, once this returns true
::DynamicSpawns.Class.UnitBlock.satisfiesTierWidth <- function( _idx, _spawnables )
{
	// The spawnable we look at, has troops in it, so we choose it to spawn units fors
	if (_spawnables[_idx].getTotal() > 0) return true;

	// Our tier has no units, but does any other higher tier has units already? If so, that one will spawn them
	foreach (spawnable in _spawnables)
	{
		if (spawnable.getTotal() > 0) return false;
	}

	// No tier has any units spawned already? Then we spawn one in the first spawnable, we look at
	return true;
}

