// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::Reforged.Spawns.Units["Unit.RF.NobleCaravanDonkey"].Cost = ::Const.World.Spawn.Troops.CaravanDonkey.Cost;

	// We enforce a much higher base resource value for the noble leader to appear, as they take a lot of those resources for themselves
	::Reforged.Spawns.Units["Unit.RF.Knight"].StartingResourceMin = 500;		// Reforged: 350
	::Reforged.Spawns.Units["Unit.RF.RF_KnightAnointed"].StartingResourceMin = 700;		// Reforged: 450

	// We enforce a higher base resource value some nobles to make them appear later
	::Reforged.Spawns.Units["Unit.RF.RF_Marshal"].StartingResourceMin = 400;	// Reforged: 350
	::Reforged.Spawns.Units["Unit.RF.RF_Herald"].StartingResourceMin = 500;		// Reforged: 350

	::Reforged.Spawns.Units["Unit.RF.RF_KnightAnointed"].StaticDefs = {
		Units = [
			{ BaseID =  "Unit.RF.RF_Squire" },	// We only ever spawn the annointed knight with one squire
		],
	};
}
