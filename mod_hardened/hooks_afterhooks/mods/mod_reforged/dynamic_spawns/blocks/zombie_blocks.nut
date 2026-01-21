{	// UnitBlock.RF.ZombieFrontline
	local zombieFrontline = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.ZombieFrontline");
	zombieFrontline.DynamicDefs.Units[2].RatioMax = 1.0;		// Reforged: 0.5
	zombieFrontline.DynamicDefs.Units.push({ BaseID = "Unit.HD.HD_ZombieBetrayer", RatioMax = 0.35 });		// New highest tier for frontline
}

{	// UnitBlock.RF.ZombieElite
	local zombieElite = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.ZombieElite");
	zombieElite.DynamicDefs.Units.push({ BaseID = "Unit.HD.HD_ZombieBetrayer" });		// New highest tier for elites
}
