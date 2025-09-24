// Hooks
{
	// Fix(Reforged): We replace instances of hard-coded costs with those from spawnlist_master
	::DynamicSpawns.Public.getUnit("Unit.RF.SandGolemMEDIUM").Cost = ::Const.World.Spawn.Troops.SandGolemMEDIUM.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.SandGolemHIGH").Cost = ::Const.World.Spawn.Troops.SandGolemHIGH.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.HexeOneSpider").Cost = ::Const.World.Spawn.Troops.Hexe.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.HexeTwoSpider").Cost = ::Const.World.Spawn.Troops.Hexe.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.HexeOneDirewolf").Cost = ::Const.World.Spawn.Troops.Hexe.Cost;
	::DynamicSpawns.Public.getUnit("Unit.RF.HexeTwoDirewolf").Cost = ::Const.World.Spawn.Troops.Hexe.Cost;
}
