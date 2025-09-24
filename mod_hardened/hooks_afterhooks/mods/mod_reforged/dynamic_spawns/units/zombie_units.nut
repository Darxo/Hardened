
// New Additions
{
	local units = [
	// Zombies
		{
			ID = "Unit.HD.HD_ZombieBetrayer",	// Fallen Hero
			Troop = "ZombieBetrayer",
			Figure = ["figure_zombie_03"],	// Fallen Hero Figure
		},
	];

	foreach (unitDef in units)
	{
		if (!("Cost" in unitDef)) unitDef.Cost <- ::Const.World.Spawn.Troops[unitDef.Troop].Cost;
		::DynamicSpawns.Public.registerUnit(unitDef);
	}
}
