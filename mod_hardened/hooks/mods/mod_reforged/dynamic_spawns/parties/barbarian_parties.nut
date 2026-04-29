
// Hooking
{
	::Reforged.Spawns.Parties["Barbarians"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Barbarians;
	::Reforged.Spawns.Parties["BarbarianHunters"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Barbarians * ::Hardened.Global.PartySizeMult.Scouts;
	::Reforged.Spawns.Parties["BarbarianKing"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Barbarians;

	local barbarians = ::Reforged.Spawns.Parties["Barbarians"];
	foreach (unitBlock in barbarians.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BarbarianDog")
		{
			unitBlock.HardMax <- 4;					// Reforged: unrestricted
		}
		else if (unitBlock.BaseID == "UnitBlock.RF.BarbarianSupport")
		{
			unitBlock.RatioMax = 0.08;				// Reforged: 0.15
			unitBlock.ExclusionChance <- 40;		// Reforged: None
		}
	}
}
