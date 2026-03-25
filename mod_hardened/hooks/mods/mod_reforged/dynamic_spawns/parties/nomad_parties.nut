{	// NomadDefenders
	local nomadDefenders = ::Reforged.Spawns.Parties["NomadDefenders"];
	foreach (unitBlock in nomadDefenders.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.NomadElite")
		{
			unitBlock.RatioMin = 0.1;	// Reforged: 0.0
			unitBlock.StartingResourceMin <- 450;	// Reforged: 0
			delete unitBlock.getSpawnWeight;
			break;
		}
	}

	// We add a new lower tier NomadElite block, which uses an exclusion chance and lower RatioMax to take up less resources
	nomadDefenders.DynamicDefs.UnitBlocks.push({
		BaseID = "UnitBlock.RF.NomadElite",
		StartingResourceMin = 350,
		ExclusionChance = 0.6,
		RatioMin = 0.0,
		RatioMax = 0.2,
	});
}

{	// NomadRaiders
	local nomadRaiders = ::Reforged.Spawns.Parties["NomadRaiders"];
	foreach (unitBlock in nomadRaiders.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.NomadElite")
		{
			unitBlock.RatioMin = 0.1;	// Reforged: 0.0
			unitBlock.StartingResourceMin <- 450;	// Reforged: 350
			delete unitBlock.getSpawnWeight;
			break;
		}
	}

	// We add a new lower tier NomadElite block, which uses an exclusion chance and lower RatioMax to take up less resources
	nomadRaiders.DynamicDefs.UnitBlocks.push({
		BaseID = "UnitBlock.RF.NomadElite",
		StartingResourceMin = 350,
		ExclusionChance = 0.6,
		RatioMin = 0.0,
		RatioMax = 0.2,
	});
}
