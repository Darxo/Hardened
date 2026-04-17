{	// UnitBlock.RF.GoblinFrontline
	local goblinFrontline = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.GoblinFrontline"];
	goblinFrontline.DynamicDefs.Units.insert(0, { BaseID = "Unit.HD.GoblinSkirmisher", StartingResourceMax = 400 });		// New lowest tier for goblin frontline
	// goblinFrontline.DynamicDefs.Units[0].StartingResourceMin <- 180;
}

{	// UnitBlock.RF.GoblinRanged
	local goblinRanged = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.GoblinRanged"];
	goblinRanged.DynamicDefs.Units.insert(0, { BaseID = "Unit.HD.GoblinAmbusher", StartingResourceMax = 400 });		// New lowest tier for goblin ranged
	// goblinRanged.DynamicDefs.Units[0].StartingResourceMin <- 180;
}
