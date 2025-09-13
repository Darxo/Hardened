// Hooking
{
	local mercParty = ::DynamicSpawns.Public.getParty("Mercenaries");
	mercParty.HardMin = 6;	// Reforged: 8
	foreach (unitBlock in mercParty.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.Wardog")
		{
			unitBlock.ExclusionChance <- 0.4;	// Reforged: 0.0
			unitBlock.HardMax <- 4;		// Reforged: unlimited
			break;
		}
	}
}

// Overwriting
{
	local parties = [
		{
			// OVerwrite, because we
			//	- remove the rare variant with high hardmin and forced mercenary spawns
			//	- greatly reduce maximum number of caravan hands
			ID = "Caravan",
			HardMin = 4,
			DefaultFigure = "cart_02",
			MovementSpeedMult = 0.5,
			VisibilityMult = 1.0,
			VisionMult = 0.25,
			StaticDefs = {
				Units = [
					{ BaseID = "Unit.RF.CaravanDonkey" },
				],
			},
			DynamicDefs = {
				UnitBlocks = [
					{ BaseID = "UnitBlock.RF.CaravanDonkey", RatioMin = 0.15, RatioMax = 0.25, PartySizeMin = 6, HardMax = 2 },	// Vanilla: Second Donkey starts spawning at 7+.  Max 3 Donkies in vanilla parties.
					{ BaseID = "UnitBlock.RF.CaravanHand", RatioMin = 0.10, RatioMax = 0.20, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.CaravanGuard", RatioMin = 0.20, RatioMax = 1.00, DeterminesFigure = false },
				],
			},
		},
	]

	foreach(partyDef in parties)
	{
		::DynamicSpawns.Public.registerParty(partyDef);
	}
}
