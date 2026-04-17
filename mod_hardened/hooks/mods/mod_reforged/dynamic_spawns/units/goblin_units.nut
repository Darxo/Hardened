// New Units
{
	local units = [
		{
			ID = "Unit.HD.GoblinSkirmisher",
			Troop = "GoblinSkirmisherLOW",
			Figure = "figure_goblin_01"
		},
		{
			ID = "Unit.HD.GoblinAmbusher",
			Troop = "GoblinAmbusherLOW",
			Figure = "figure_goblin_02"
		},
	];

	foreach (unitDef in units)
	{
		::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
	}
}
