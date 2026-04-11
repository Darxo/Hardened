{	// UnitBlock.RF.BanditFast
	local banditFast = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.BanditFast"];
	banditFast.DynamicDefs.Units.remove(0);		// The first two entries are BanditRobber and we want one of them gone
	banditFast.getUpgradeWeight <- function() { return base.getUpgradeWeight() * 0.8 };	// This is new and used to roughly imitate the Reforged robber upgrading
	banditFast.TierWidth <- 2;		// Reforged: unrestricted;
}

{	// UnitBlock.RF.BanditTough
	local banditTough = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.BanditTough"];
	banditTough.DynamicDefs.Units[0].HardMax <- 0;		// We permenantly prevent the lowest Reforged tough tier from spawning, by setting its HardMax to 0, to keep compatibility with Reforged
	banditTough.getUpgradeWeight <- function() { return base.getUpgradeWeight() * 0.8 };	// Slower upgrading to stay in line with the 4-tier blocks
	banditTough.TierWidth <- 2;		// Reforged: unrestricted;
}

{	// UnitBlock.RF.BanditRanged
	local banditRanged = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.BanditRanged"];
	banditRanged.getUpgradeWeight <- function() { return base.getUpgradeWeight() * 0.8 };	// Slower upgrading to stay in line with the 4-tier blocks
	banditRanged.TierWidth <- 2;		// Reforged: unrestricted;
}

{	// UnitBlock.RF.BanditBoss
	local banditBoss = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.BanditBoss"];
	banditBoss.DynamicDefs.Units.insert(0, { BaseID = "Unit.RF.RF_BanditMarauder" });		// T4 Balanced Bandit is new lowest tier for bandit leader
	banditBoss.DynamicDefs.Units[1].StartingResourceMin <- 250;		// Prevent too early upgrading into second tier
	banditBoss.TierWidth <- 2;		// Reforged: unrestricted;
}

{	// UnitBlock.RF.BanditDisguisedDirewolf
	local banditDirewolfs = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.BanditDisguisedDirewolf"];
	banditDirewolfs.DynamicDefs.Units.insert(1, { BaseID = "Unit.RF.RF_BanditHighwayman", HardMax = 3 });		// T3 Fast Bandits are new highest tier for disguised bandits
	banditDirewolfs.TierWidth <- 2;		// Reforged: unrestricted;
}
