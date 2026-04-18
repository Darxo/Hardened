{	// New Units
	local units = [
		{
			ID = "Unit.HD.OrcYoung",
			Troop = "OrcYoungLOW",
			Figure = "figure_orc_06",
		},
	];

	foreach (unitDef in units)
	{
		::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
	}
}

{	// Hooks
	// We remove the figure without a helmet
	::Reforged.Spawns.Units["Unit.RF.OrcYoung"].Figure = "figure_orc_02";
}
