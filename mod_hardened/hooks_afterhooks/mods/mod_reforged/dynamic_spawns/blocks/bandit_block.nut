{	// UnitBlock.RF.BanditFast
	local banditFast = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.BanditFast");
	banditFast.DynamicDefs.Units.remove(0);		// The first two entries are BanditRobber and we want one of them gone
	banditFast.Class.getUpgradeWeight <- function() { return base.getUpgradeWeight() * 0.80 };	// This is new and used to roughly imitate the Reforged robber upgrading
}

{	// UnitBlock.RF.BanditBoss
	local banditBoss = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.BanditBoss");
	banditBoss.DynamicDefs.Units.insert(0, { BaseID = "Unit.RF.RF_BanditHighwayman" });		// New lowest tier for bandit leader
	banditBoss.DynamicDefs.Units[1].StartingResourceMin <- 250;		// Prevent too early upgrading into second tier
}

