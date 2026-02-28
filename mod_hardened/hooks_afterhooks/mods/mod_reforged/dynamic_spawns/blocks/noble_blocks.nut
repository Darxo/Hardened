{	// UnitBlock.RF.CaravanGuard
	local nobleFrontline = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.NobleFrontline");
	nobleFrontline.DynamicDefs.Units.push({ BaseID = "Unit.RF.RF_ManAtArms", RatioMax = 0.2 });		// ManAtArms are now a higher tier noble frontline

	local nobleFrontline = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.NobleElite");
	// We reduce the weight of Man at Arms, because they are already somewhat guaranteed
	nobleFrontline.DynamicDefs.Units.setWeight("Unit.RF.RF_ManAtArms", 0.5);	// Reforged: 1.0
}
