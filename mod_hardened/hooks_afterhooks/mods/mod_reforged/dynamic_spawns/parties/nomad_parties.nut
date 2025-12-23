foreach (unitBlock in ::DynamicSpawns.Public.getParty("NomadDefenders").DynamicDefs.UnitBlocks)
{
	if (unitBlock.BaseID == "UnitBlock.RF.NomadElite")
	{
		unitBlock.RatioMin = 0.1;	// Reforged: 0.0
		unitBlock.StartingResourceMin <- 450;	// Reforged: 0
		if ("getSpawnWeight" in unitBlock) unitBlock.rawdelete("getSpawnWeight");	// Reforged: 0.2
		break;
	}
}

// We add a new lower tier NomadElite block, which uses an exclusion chance and lower RatioMax to take up less resources
::DynamicSpawns.Public.getParty("NomadDefenders").DynamicDefs.UnitBlocks.push({
	BaseID = "UnitBlock.RF.NomadElite",
	StartingResourceMin = 300,
	ExclusionChance = 0.5,
	RatioMin = 0.0,
	RatioMax = 0.2,
});

foreach (unitBlock in ::DynamicSpawns.Public.getParty("NomadRaiders").DynamicDefs.UnitBlocks)
{
	if (unitBlock.BaseID == "UnitBlock.RF.NomadElite")
	{
		unitBlock.RatioMin = 0.1;	// Reforged: 0.0
		unitBlock.StartingResourceMin <- 450;	// Reforged: 0
		if ("getSpawnWeight" in unitBlock) unitBlock.rawdelete("getSpawnWeight");	// Reforged: 0.2
		break;
	}
}

// We add a new lower tier NomadElite block, which uses an exclusion chance and lower RatioMax to take up less resources
::DynamicSpawns.Public.getParty("NomadRaiders").DynamicDefs.UnitBlocks.push({
	BaseID = "UnitBlock.RF.NomadElite",
	StartingResourceMin = 300,
	ExclusionChance = 0.5,
	RatioMin = 0.0,
	RatioMax = 0.2,
});
