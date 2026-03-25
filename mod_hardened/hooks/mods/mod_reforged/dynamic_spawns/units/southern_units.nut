// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::Reforged.Spawns.Units["Unit.RF.SouthernDonkey"].Cost = ::Const.World.Spawn.Troops.SouthernDonkey.Cost;
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
		::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
	}
}
