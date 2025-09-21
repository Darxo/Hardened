// Hooking
{
	local necromancerParty = ::DynamicSpawns.Public.getParty("Necromancer");
	necromancerParty.HardMin = 6;	// Reforged: 10
	foreach (unitBlock in necromancerParty.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.Ghost")
		{
			unitBlock.ExclusionChance <- 0.3;
			unitBlock.PartySizeMin <- 7;
		}
		else if (unitBlock.BaseID == "UnitBlock.RF.NecromancerWithBodyguards")
		{
			unitBlock.HardMin <- 1;	// We guarantee one necromancer, because of how this party is expected to work
			unitBlock.RatioMin = 0.0;	// Refroged: 0.04
			unitBlock.RatioMax = 0.1;	// Reforged: 0.09
		}
	}
	// Necromancer parties can sometimes throw in a random extra necromancer
	necromancerParty.DynamicDefs.UnitBlocks.push({
		BaseID = "UnitBlock.RF.NecromancerWithBodyguards",
		PartySizeMin = 15,
		ExclusionChance = 0.7,
		HardMin = 1,
		HardMax = 1,
	});
}
