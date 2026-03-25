
// Hooking
{
	local barbarians = ::Reforged.Spawns.Parties["Barbarians"];
	foreach (unitBlock in barbarians.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BarbarianDog")
		{
			unitBlock.HardMax <- 4;					// Reforged: unrestricted
		}
	}
}
