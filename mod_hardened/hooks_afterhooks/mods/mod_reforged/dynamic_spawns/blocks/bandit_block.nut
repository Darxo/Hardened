local unitBlocks = [
	{
		ID = "UnitBlock.RF.BanditFast",
		DeterminesFigure = true,
		UnitDefs = [
			{ BaseID = "Unit.RF.RF_BanditRobber" },
			{ BaseID = "Unit.RF.RF_BanditBandit" },
			{ BaseID = "Unit.RF.RF_BanditKiller" },
		],
		getUpgradeWeight = function() { return base.getUpgradeWeight() * 0.80 },	// This is new and used to roughly imitate the Reforged robber upgrading
	},
	{
		ID = "UnitBlock.RF.BanditBoss",
		DeterminesFigure = true,
		UnitDefs = [
			{ BaseID = "Unit.RF.RF_BanditHighwayman" },	// Low level "Leader"-like. Allows more guaranteed mid-level gear a bit earlier
			{ BaseID = "Unit.RF.BanditLeader", StartingResourceMin = 250 },	// Same as Reforged has defined for any
			{ BaseID = "Unit.RF.RF_BanditBaron", HardMax = 1 },
		],
	},
];

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}

