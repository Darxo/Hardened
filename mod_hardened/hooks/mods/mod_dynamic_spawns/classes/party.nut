// Return the number of troops up until that one, no upgrading may happen
// This is meant to be overwritten by parties, which want to upgrade earlier or later
::DynamicSpawns.Class.Party.generateIdealSize <- function()
{
	return ::Hardened.util.genericGenerateIdealSize();
}

// Remove a spawnable, no matter how deep it is hiding within this spawnable
::DynamicSpawns.Class.Party.removeSpawnable <- function( _id, _all = true )
{
	return base.removeSpawnable(_id, _all);
}
