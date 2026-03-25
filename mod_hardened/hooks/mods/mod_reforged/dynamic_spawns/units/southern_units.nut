// Hooks
{
}

// New Units
{
	local units = [
		{
			ID = "Unit.HD.Gladiator",
			Troop = "Gladiator",
		},
	];

	foreach (unitDef in units)
	{
		::Reforged.Spawns.Units[unitDef.ID] <- unitDef;
	}
}
