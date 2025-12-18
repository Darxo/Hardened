// Introduce new function for getting the startingResources cost of a spawnable
// This function is meant to be used for determining whether a unit can spawn and how to sort units inside of UnitBlocks (if those units have bodyguards)
::DynamicSpawns.Class.Spawnable.getStartingResources <- function()
{
	return 0;
}
