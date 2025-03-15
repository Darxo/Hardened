foreach (unitBlock in ::DynamicSpawns.Public.getParty("BanditRaiders").DynamicDefs.UnitBlocks)
{
	if (unitBlock.BaseID == "UnitBlock.RF.BanditBoss" && "StartingResourceMin" in unitBlock)
	{
		// We lower the Resource Requirement for Leader because we add a new lower tier leader unit
		unitBlock.StartingResourceMin = 180;	// In Reforged this is 250
		break;
	}
}

foreach (unitBlock in ::DynamicSpawns.Public.getParty("BanditDefenders").DynamicDefs.UnitBlocks)
{
	if (unitBlock.BaseID == "UnitBlock.RF.BanditBoss" && "StartingResourceMin" in unitBlock)
	{
		// We lower the Resource Requirement for Leader because we add a new lower tier leader unit
		unitBlock.StartingResourceMin = 180;	// In Reforged this is 250
		break;
	}
}
