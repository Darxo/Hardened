{	// UnitBlock.RF.NomadLeader
	local nomadLeader = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.NomadLeader");
	nomadLeader.DynamicDefs.Units.insert(0, { BaseID = "Unit.RF.NomadOutlaw" });		// New lowest tier for nomad leader
	nomadLeader.DynamicDefs.Units[0].StartingResourceMin <- 180;		// Prevent too early spawn of first Nomad Outlaw
}
