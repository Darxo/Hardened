

// Hooking
{
	{	// Alps
		local alpParty = ::DynamicSpawns.Public.getParty("Alps");
		foreach (unitBlock in alpParty.DynamicDefs.UnitBlocks)
		{
			if (unitBlock.BaseID == "UnitBlock.RF.Alp")
			{
				unitBlock.RatioMin = 0.5;
			}
		}

		// We sometimes add direwolfs into the mix to support alps, just like vanilla does it
		alpParty.DynamicDefs.UnitBlocks.push({
			BaseID = "UnitBlock.RF.Direwolf",
			ExclusionChance = 0.75,		// Roughly 25% of vanilla alp party configurations contain direwolfs
			RatioMin = 0.1,
			RatioMax = 0.35,
			PartySizeMin = 6,
		});
	}

	{	// Ghouls
		local ghoulParty = ::DynamicSpawns.Public.getParty("Ghouls");
		ghoulParty.generateIdealSize <- function()
		{
			local ret = ::Hardened.util.genericGenerateIdealSize();
			ret *= 1.5;		// Ghouls always come in larger sizes than the player party
			return ret;
		}
	}
}

// Overwriting
{
	local parties = [
		{
			// Overwrite, because we
			//	- add many ExclusionChane modifiers to prevent overload of exotic animals
			//	- remove the StartingResourceMin for HexeBandits
			//	- prevent animals from dictating the DefaultFigure
			ID = "HexenAndMore",
			DefaultFigure = "figure_hexe_01",
			MovementSpeedMult = 1.0,
			VisibilityMult = 1.0,
			VisionMult = 1.0,
			DynamicDefs = {
				UnitBlocks = [
					{ BaseID = "UnitBlock.RF.HexeWithBodyguard", StartingResourceMin = 0, HardMin = 1, HardMax = 1 },	// We guarantee one hexe in every party but also allow it to upgrade its bodyguards using resources
					{ BaseID = "UnitBlock.RF.HexeWithBodyguard", StartingResourceMin = 150, RatioMin = 0.08, RatioMax = 0.15 },
					{ BaseID = "UnitBlock.RF.Spider", ExclusionChance = 0.3, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Ghoul", ExclusionChance = 0.3, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Direwolf", ExclusionChance = 0.3, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.HexeBandit", StartingResourceMin = 0, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.HexeBanditRanged", RatioMax = 0.20, ExclusionChance = 0.6, StartingResourceMin = 0, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Schrat", StartingResourceMin = 250, ExclusionChance = 0.6, function getSpawnWeight() { return base.getSpawnWeight() * 0.50}, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.UnholdBog", StartingResourceMin = 250, ExclusionChance = 0.6, function getSpawnWeight() { return base.getSpawnWeight() * 0.50}, DeterminesFigure = false },
				],
			},
		},
		{
			// Overwrite, because we
			//	- add many ExclusionChane modifiers to prevent overload of exotic animals
			//	- remove the StartingResourceMin for HexeBandits
			//	- prevent animals from dictating the DefaultFigure
			ID = "HexenAndNoSpiders",
			DefaultFigure = "figure_hexe_01",
			MovementSpeedMult = 1.0,
			VisibilityMult = 1.0,
			VisionMult = 1.0,
			DynamicDefs = {
				UnitBlocks = [
					{ BaseID = "UnitBlock.RF.HexeNoSpider", StartingResourceMin = 0, HardMin = 1, HardMax = 1 },	// We guarantee one hexe in every party but also allow it to upgrade its bodyguards using resources
					{ BaseID = "UnitBlock.RF.HexeNoSpider", StartingResourceMin = 150, RatioMin = 0.08, RatioMax = 0.15 },
					{ BaseID = "UnitBlock.RF.Ghoul", ExclusionChance = 0.3, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Direwolf", ExclusionChance = 0.3, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.HexeBandit", StartingResourceMin = 0, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.HexeBanditRanged", RatioMax = 0.20, ExclusionChance = 0.6, StartingResourceMin = 0, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Schrat", StartingResourceMin = 250, ExclusionChance = 0.6, function getSpawnWeight() { return base.getSpawnWeight() * 0.50}, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.UnholdBog", StartingResourceMin = 250, ExclusionChance = 0.6, function getSpawnWeight() { return base.getSpawnWeight() * 0.50}, DeterminesFigure = false },
				],
			},
		},
	];

	foreach(partyDef in parties)
	{
		::DynamicSpawns.Public.registerParty(partyDef);
	}
}
