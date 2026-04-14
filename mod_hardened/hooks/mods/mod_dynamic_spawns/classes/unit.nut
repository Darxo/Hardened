// Overwrite to replace usage of getCost with getPredictedWorth
::DynamicSpawns.Class.Unit.getUpgradeWeight <- function()
{
	return this.getTotal() / ::Math.pow(this.getPredictedWorth(), 2);
}

// Introduce new function for getting the startingResources cost of a spawnable
// This function is meant to be used for determining whether a unit can spawn and how to sort units inside of UnitBlocks (if those units have bodyguards)
::DynamicSpawns.Class.Unit.getStartingResources <- function()
{
	return 0;
}

// Remove a spawnable, no matter how deep it is hiding within this spawnable
::DynamicSpawns.Class.Unit.removeSpawnable <- function( _id, _all = true )
{
	return base.removeSpawnable(_id, _all);
}

