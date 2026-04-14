// Introduce new function for getting the startingResources cost of a spawnable
// This function is meant to be used for determining whether a unit can spawn and how to sort units inside of UnitBlocks (if those units have bodyguards)
::DynamicSpawns.Class.Spawnable.getStartingResources <- function()
{
	return 0;
}

// Remove a spawnable, no matter how deep it is hiding within this spawnable
::DynamicSpawns.Class.Spawnable.removeSpawnable <- function( _id, _all = true )
{
	local function parseId( _idToParse )
	{
		local idx = _idToParse.find("(in"); // find the (instance 0x233e234f) suffix and remove it
		return idx != null && idx != 0 ? _idToParse.slice(0, idx) : _idToParse;
	}

	local parsedId = parseId(_id);

	local removed = false;
	foreach (index, spawnable in this.__DynamicSpawnables)
	{
		if (parseId(spawnable.getID()) == parsedId)
		{
			removed = __DynamicSpawnables.remove(index);
			if (removed && !_all) return true;
		}

		removed = spawnable.removeSpawnable(_id);
		if (removed && !_all) return true;
	}

	foreach (index, spawnable in this.__StaticSpawnables)
	{
		if (parseId(spawnable.getID()) == parsedId)
		{
			removed = __StaticSpawnables.remove(index);
			if (removed && !_all) return true;
		}

		removed = spawnable.removeSpawnable(_id);
		if (removed && !_all) return true;
	}

	return removed;
}
