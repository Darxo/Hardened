{	// UnitBlock.RF.CaravanGuard
	local caravanGuards = ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.CaravanGuard");
	caravanGuards.DynamicDefs.Units.push({ BaseID = "Unit.RF.Mercenary", StartingResourceMin = 200 });		// Mercenaries are now a higher tier CaravanGuard

	// Caravan Hands are now the lowest tier of CaravanGuard
	// This is done as a trick to make transition from hands to guards more fluent as resources grow
	caravanGuards.DynamicDefs.Units.push({ BaseID = "Unit.RF.CaravanHand" });
}
