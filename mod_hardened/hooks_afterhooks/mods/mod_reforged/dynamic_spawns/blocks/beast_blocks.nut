// Hooks
{
	{	// UnitBlock.RF.Ghoul
		local ghoulBlock = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.Ghoul");
		foreach (unitDef in ghoulBlock.DynamicDefs.Units)
		{
			if (unitDef.BaseID == "Unit.RF.GhoulHIGH")
			{
				unitDef.RatioMax = 0.4;		// Reforged: 0.2
			}
		}
	}
}
