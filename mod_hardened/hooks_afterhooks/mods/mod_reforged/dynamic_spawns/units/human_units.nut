local units = [
	// We overwrite these Reforged units, because currently overwriting is much more convinient than trying to hook it
	{
		ID = "Unit.RF.RF_KnightAnointed",
		Troop = "RF_KnightAnointed",
		Figure = "figure_noble_03",
		StartingResourceMin = 450,
		StaticDefs = {
			Units = [
				{ BaseID =  "Unit.RF.RF_Squire" },	// We only ever spawn the annointed knight with one squire
			],
		},
	},
];

foreach (unitDef in units)
{
	if (!("Cost" in unitDef)) unitDef.Cost <- ::Const.World.Spawn.Troops[unitDef.Troop].Cost;
	::DynamicSpawns.Public.registerUnit(unitDef);
}

