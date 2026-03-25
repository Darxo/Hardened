{	// UnitBlock.RF.ZombieFrontline
	local zombieFrontline = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.ZombieFrontline"];
	zombieFrontline.DynamicDefs.Units[0].RatioMin = 0.0;		// Reforged: 0.05
	zombieFrontline.DynamicDefs.Units[2].RatioMax = 1.0;		// Reforged: 0.3
	zombieFrontline.DynamicDefs.Units[3].RatioMax = 0.35;		// Reforged: 0.25
}

{	// UnitBlock.RF.ZombieBodyguard
	local zombieBodyguards = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.ZombieBodyguard"];
	foreach (key, entry in zombieBodyguards.DynamicDefs.Units)
	{
		if (entry.BaseID == "Unit.RF.RF_ZombieHeroBodyguard")
		{
			// We prevent Fallen Heroes from being bodyguards
			zombieBodyguards.DynamicDefs.Units.remove(key);
			break;
		}
	}
}

{	// UnitBlock.RF.ZombieBodyguardNomad
	local zombieBodyguardNomad = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.ZombieBodyguardNomad"];
	foreach (key, entry in zombieBodyguardNomad.DynamicDefs.Units)
	{
		if (entry.BaseID == "Unit.RF.RF_ZombieHeroBodyguard")
		{
			// We prevent Fallen Heroes from being nomad bodyguards
			zombieBodyguardNomad.DynamicDefs.Units.remove(key);
			break;
		}
	}
}
