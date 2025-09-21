
// Hooking
{
	foreach (unitBlock in ::DynamicSpawns.Public.getParty("Barbarians").DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BarbarianBeastmaster")
		{
			unitBlock.StartingResourceMin <- 400;	// Reforged: 0
			unitBlock.RatioMin <- 0.05;				// Reforged: 0.0
			unitBlock.ExclusionChance <- 0.1;		// Reforged: 0.0
			unitBlock.PartySizeMin <- 10;			// Reforged: 5
		}
		else if (unitBlock.BaseID == "UnitBlock.RF.BarbarianDog")
		{
			unitBlock.ExclusionChance <- 0.5;		// Reforged 0.0
		}
	}
	// We add a new lower tier barbarian beastmaster block, so that you will see lower camps more often without unholds
	::DynamicSpawns.Public.getParty("Barbarians").DynamicDefs.UnitBlocks.push({
		BaseID = "UnitBlock.RF.BarbarianBeastmaster",
		StartingResourceMax = 399,
		ExclusionChance = 0.5,
		RatioMin = 0.00,
		RatioMax = 0.1,
		PartySizeMin = 6,
	})
}
