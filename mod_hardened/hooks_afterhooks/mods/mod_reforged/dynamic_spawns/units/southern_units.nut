// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::DynamicSpawns.Public.getUnit("Unit.RF.SouthernDonkey").Cost = ::Const.World.Spawn.Troops.SouthernDonkey.Cost;
}

// New Units
{
	local units = [
		{
			ID = "Unit.HD.Gladiator",
			Troop = "Gladiator",
		},
	];

	foreach (unitDef in units)
	{
		if (!("Cost" in unitDef))
			unitDef.Cost <- ::Const.World.Spawn.Troops[unitDef.Troop].Cost;
		::DynamicSpawns.Public.registerUnit(unitDef);
	}
}
