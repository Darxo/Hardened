// Introduce new virtual function for getting the minimum cost of a spawnable
// This function is meant to be used for determining whether a unit can spawn and how to sort units inside of UnitBlocks (if those units have bodyguards)
::DynamicSpawns.Class.Spawnable.getMinCost <- function()
{
	return 0;
}
