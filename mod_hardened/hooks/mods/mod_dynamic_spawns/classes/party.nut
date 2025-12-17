// Implement getMinCost for party
// Return the cost of this party, if it was spawned with 0 available resources
// As a result only static spawnables and those, forced with HardMin > 0 will spawn and contribute to the MinCost
// The same call might still result in varying results, if a bodyguard definition uses a HardMin but randomized unitblock
::DynamicSpawns.Class.Party.getMinCost <- function()
{
	local wasLogging = ::DynamicSpawns.Const.Logging
	::DynamicSpawns.Const.Logging = false;
	local ret = (clone this).init().spawn(0).getWorth();
	::DynamicSpawns.Const.Logging = wasLogging;
	return ret;
}
