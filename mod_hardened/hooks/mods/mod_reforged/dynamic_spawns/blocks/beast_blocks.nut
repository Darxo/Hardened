// Hooks
{
	{	// UnitBlock.RF.Ghoul
		local ghoulBlock = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.Ghoul"];
		foreach (unitDef in ghoulBlock.DynamicDefs.Units)
		{
			if (unitDef.BaseID == "Unit.RF.GhoulHIGH")
			{
				unitDef.RatioMax <- 0.4;
			}
		}
	}

	{	// UnitBlock.RF.GhoulLowOnly
		local ghoulBlock = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.GhoulLowOnly"];
		ghoulBlock.DynamicDefs.Units.push({
			BaseID = "Unit.RF.Ghoul",
			RatioMax =  0.7,
		});
	}
}
