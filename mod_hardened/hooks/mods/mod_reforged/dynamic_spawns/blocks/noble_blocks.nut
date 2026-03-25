{	// UnitBlock.RF.CaravanGuard
	local nobleFrontline = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.NobleFrontline"];
	nobleFrontline.DynamicDefs.Units.push({ BaseID = "Unit.RF.RF_ManAtArms", RatioMax = 0.2 });		// ManAtArms are now a higher tier noble frontline

	local nobleElite = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.NobleElite"];
	// We reduce the weight of Man at Arms, because they are already somewhat guaranteed
	nobleElite.DynamicDefs.Units.setWeight("Unit.RF.RF_ManAtArms", 0.5);	// Reforged: 1.0
}
