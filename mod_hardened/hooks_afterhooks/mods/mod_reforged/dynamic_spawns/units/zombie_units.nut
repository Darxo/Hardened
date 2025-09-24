// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::DynamicSpawns.Public.getUnit("Unit.RF.NecromancerN").Cost = ::Const.World.Spawn.Troops.Necromancer.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.NecromancerNN").Cost = ::Const.World.Spawn.Troops.Necromancer.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.NecromancerNNN").Cost = ::Const.World.Spawn.Troops.Necromancer.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.NecromancerY").Cost = ::Const.World.Spawn.Troops.Necromancer.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.NecromancerK").Cost = ::Const.World.Spawn.Troops.Necromancer.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.NecromancerYK").Cost = ::Const.World.Spawn.Troops.Necromancer.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.NecromancerKK").Cost = ::Const.World.Spawn.Troops.Necromancer.Cost;
}

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
