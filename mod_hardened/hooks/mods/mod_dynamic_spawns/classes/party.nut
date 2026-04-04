// Return the number of troops up until that one, no upgrading may happen
// This is meant to be overwritten by parties, which want to upgrade earlier or later
::DynamicSpawns.Class.Party.generateIdealSize <- function()
{
	return ::Hardened.util.genericGenerateIdealSize();
}
