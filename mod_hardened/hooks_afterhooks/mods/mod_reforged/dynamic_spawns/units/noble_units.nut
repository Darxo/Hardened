// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::DynamicSpawns.Public.getUnit("Unit.RF.NobleCaravanDonkey").Cost = ::Const.World.Spawn.Troops.CaravanDonkey.Cost;
}
