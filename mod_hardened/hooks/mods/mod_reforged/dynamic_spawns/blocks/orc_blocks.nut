{	// UnitBlock.RF.OrcYoung
	local orcYoungLine = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.OrcYoung"];
	orcYoungLine.DynamicDefs.Units.insert(0, { BaseID = "Unit.HD.OrcYoung", StartingResourceMax = 400 });		// New lowest tier for orc young line
}
