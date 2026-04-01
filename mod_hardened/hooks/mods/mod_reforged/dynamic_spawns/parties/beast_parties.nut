// Hooking
{
	{	// Alps
	}

	{	// Ghouls
		local ghoulParty = ::Reforged.Spawns.Parties["Ghouls"];
		// We remove Reforged adjustments during onBeforeSpawnStart where they set custom Ratios and StartingResource on a unit-basis
		delete ghoulParty.onBeforeSpawnStart;
	}
}

// Overwriting
{
	local parties = [
		{
			// Overwrite, because we
			//	- use ExclusionChane modifiers to prevent overload of exotic animals
			//	- remove the StartingResourceMin for HexeBandits
			//	- prevent animals from dictating the DefaultFigure
			//	- allow much more combinations of different units
			ID = "HexenAndMore",
			DefaultFigure = "figure_hexe_01",
			MovementSpeedMult = 1.0,
			VisibilityMult = 1.0,
			VisionMult = 1.0,
			HardMin = 2,
			DynamicDefs = {
				UnitBlocks = [
					{ BaseID = "UnitBlock.RF.HexeWithBodyguard", StartingResourceMin = 0, HardMin = 1, HardMax = 1 },	// We guarantee one hexe in every party but also allow it to upgrade its bodyguards using resources
					{ BaseID = "UnitBlock.RF.HexeWithBodyguard", StartingResourceMin = 200, RatioMin = 0.08, RatioMax = 0.15 },
					{ BaseID = "UnitBlock.RF.Spider", ExclusionChance = 30, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Ghoul", ExclusionChance = 30, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Direwolf", ExclusionChance = 30, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.HexeBandit", StartingResourceMin = 0, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.HexeBanditRanged", RatioMax = 0.20, ExclusionChance = 60, StartingResourceMin = 0, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Schrat", StartingResourceMin = 250, ExclusionChance = 60, function getSpawnWeight() { return base.getSpawnWeight() * 0.50}, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.UnholdBog", StartingResourceMin = 250, ExclusionChance = 60, function getSpawnWeight() { return base.getSpawnWeight() * 0.50}, DeterminesFigure = false },
				],
			},
		},
		{
			// Overwrite, because we
			//	- use ExclusionChane modifiers to prevent overload of exotic animals
			//	- remove the StartingResourceMin for HexeBandits
			//	- prevent animals from dictating the DefaultFigure
			//	- allow much more combinations of different units
			ID = "HexenAndNoSpiders",
			DefaultFigure = "figure_hexe_01",
			MovementSpeedMult = 1.0,
			VisibilityMult = 1.0,
			VisionMult = 1.0,
			HardMin = 2,
			DynamicDefs = {
				UnitBlocks = [
					{ BaseID = "UnitBlock.RF.HexeNoSpider", StartingResourceMin = 0, HardMin = 1, HardMax = 1 },	// We guarantee one hexe in every party but also allow it to upgrade its bodyguards using resources
					{ BaseID = "UnitBlock.RF.HexeNoSpider", StartingResourceMin = 200, RatioMin = 0.08, RatioMax = 0.15 },
					{ BaseID = "UnitBlock.RF.Ghoul", ExclusionChance = 30, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Direwolf", ExclusionChance = 30, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.HexeBandit", StartingResourceMin = 0, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.HexeBanditRanged", RatioMax = 0.20, ExclusionChance = 60, StartingResourceMin = 0, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Schrat", StartingResourceMin = 250, ExclusionChance = 60, function getSpawnWeight() { return base.getSpawnWeight() * 0.50}, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.UnholdBog", StartingResourceMin = 250, ExclusionChance = 60, function getSpawnWeight() { return base.getSpawnWeight() * 0.50}, DeterminesFigure = false },
				],
			},
		},
	];

	foreach(partyDef in parties)
	{
		::Reforged.Spawns.Parties[partyDef.ID] <- partyDef;
	}
}
