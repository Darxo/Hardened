// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::DynamicSpawns.Public.getUnit("Unit.RF.CaravanDonkey").Cost = ::Const.World.Spawn.Troops.CaravanDonkey.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.MilitiaVeteran").Cost = ::Const.World.Spawn.Troops.MilitiaVeteran.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.MilitiaCaptain").Cost = ::Const.World.Spawn.Troops.MilitiaCaptain.Cost;
}

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

