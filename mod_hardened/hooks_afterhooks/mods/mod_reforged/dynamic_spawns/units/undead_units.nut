// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::DynamicSpawns.Public.getUnit("Unit.RF.SkeletonPriestP").Cost = ::Const.World.Spawn.Troops.SkeletonPriest.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.SkeletonPriestPP").Cost = ::Const.World.Spawn.Troops.SkeletonPriest.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.SkeletonPriestPH").Cost = ::Const.World.Spawn.Troops.SkeletonPriest.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.SkeletonPriestHH").Cost = ::Const.World.Spawn.Troops.SkeletonPriest.Cost;
}
