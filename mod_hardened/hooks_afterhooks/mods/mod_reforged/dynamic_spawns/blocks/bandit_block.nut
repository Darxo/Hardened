{	// UnitBlock.RF.BanditFast
	local banditFast = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.BanditFast");
	banditFast.DynamicDefs.Units.remove(0);		// The first two entries are BanditRobber and we want one of them gone
	banditFast.Class.getUpgradeWeight <- function() { return base.getUpgradeWeight() * 0.80 };	// This is new and used to roughly imitate the Reforged robber upgrading
}

{	// UnitBlock.RF.BanditTough
	local banditTough = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.BanditTough");
	banditTough.DynamicDefs.Units.remove(0);		// We permenantly prevent the lowest Reforged tough tier from spawning
	banditTough.Class.getUpgradeWeight <- function() { return base.getUpgradeWeight() * 0.80 };	// Slower upgrading to stay in line with the 4-tier blocks
}

{	// UnitBlock.RF.BanditBoss
	local banditBoss = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.BanditBoss");
	banditBoss.DynamicDefs.Units.insert(0, { BaseID = "Unit.RF.RF_BanditHighwayman" });		// New lowest tier for bandit leader
	banditBoss.DynamicDefs.Units[1].StartingResourceMin <- 250;		// Prevent too early upgrading into second tier
}

{	// UnitBlock.RF.BanditDisguisedDirewolf
	local banditDirewolfs = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.BanditDisguisedDirewolf");
	banditDirewolfs.DynamicDefs.Units.insert(1, { BaseID = "Unit.RF.RF_BanditKiller", HardMax = 3 });		// Bandit Killer are new highest tier for disguised bandits
}

