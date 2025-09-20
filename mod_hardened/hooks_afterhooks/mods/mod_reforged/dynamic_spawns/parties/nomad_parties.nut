foreach (unitBlock in ::DynamicSpawns.Public.getParty("NomadDefenders").DynamicDefs.UnitBlocks)
{
	if (unitBlock.BaseID == "UnitBlock.RF.NomadElite")
	{
		unitBlock.RatioMin = 0.1;	// Reforged: 0.0
		unitBlock.StartingResourceMin <- 300;	// Reforged: 0
		if ("getSpawnWeight" in unitBlock) unitBlock.rawdelete("getSpawnWeight");	// Reforged: 0.2
		break;
	}
}

foreach (unitBlock in ::DynamicSpawns.Public.getParty("NomadRaiders").DynamicDefs.UnitBlocks)
{
	if (unitBlock.BaseID == "UnitBlock.RF.NomadElite")
	{
		unitBlock.RatioMin = 0.1;	// Reforged: 0.0
		unitBlock.StartingResourceMin <- 300;	// Reforged: 0
		if ("getSpawnWeight" in unitBlock) unitBlock.rawdelete("getSpawnWeight");	// Reforged: 0.2
		break;
	}
}
