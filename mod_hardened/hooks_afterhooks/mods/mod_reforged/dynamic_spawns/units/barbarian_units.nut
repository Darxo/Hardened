// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::DynamicSpawns.Public.getUnit("Unit.RF.BarbarianBeastmasterU").Cost = ::Const.World.Spawn.Troops.BarbarianBeastmaster.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.BarbarianBeastmasterUU").Cost = ::Const.World.Spawn.Troops.BarbarianBeastmaster.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.BarbarianBeastmasterF").Cost = ::Const.World.Spawn.Troops.BarbarianBeastmaster.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.BarbarianBeastmasterFF").Cost = ::Const.World.Spawn.Troops.BarbarianBeastmaster.Cost;
}
