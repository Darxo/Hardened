local parties = [
	{
		// Changes:
		//	- Dogs stop spawning at Party size of 20
		//	- Support has 0.2 ExclusionChance (up from 0.05)
		//	- Officer is restricted to 1
		ID = "Noble",
		HardMin = 8,
		DefaultFigure = "figure_noble_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UpgradeChance = 0.50,
		DynamicDefs = {
			UnitBlocks = [
				{ BaseID = "UnitBlock.RF.NobleFrontline", RatioMin = 0.30, RatioMax = 1.00 },
				{ BaseID = "UnitBlock.RF.NobleBackline", RatioMax = 0.30 },
				{ BaseID = "UnitBlock.RF.NobleRanged", RatioMax = 0.25, },
				{ BaseID = "UnitBlock.RF.NobleElite",  RatioMin = 0.1, RatioMax = 0.25, PartySizeMin = 15, ExclusionChance = 0.2 }, // vanilla greatswords spawn at 19+
				{ BaseID = "UnitBlock.RF.NobleSupport", RatioMin = 1.0, HardMax = 1, PartySizeMin = 10, ExclusionChance = 0.3 },
				{ BaseID = "UnitBlock.RF.NobleSupport", RatioMin = 1.0, HardMax = 1, PartySizeMin = 20, ExclusionChance = 0.3 },
				{ BaseID = "UnitBlock.RF.NobleOfficer", RatioMin = 1.0, HardMax = 1,  PartySizeMin = 15, ExclusionChance = 0.3 }, // vanilla sergeants spawn at 8+
				{ BaseID = "UnitBlock.RF.NobleLeader", HardMax = 2, PartySizeMin = 20 }, // vanilla knights spawn at 18+
				{ BaseID = "UnitBlock.RF.NobleFlank", RatioMax = 0.25, HardMax = 3, ExclusionChance = 0.4, PartySizeMax = 20 },		// dogs only spawn in smaller parties
			],
		},

		function excludeSpawnables()
		{
			base.excludeSpawnables();

			local maxEliteTypes = 2;	// We make sure, that no roaming party contains more than this many elites will appear at the same time
			foreach (index, nobleBlock in this.__DynamicSpawnables)
			{
				if (nobleBlock.getID().find("UnitBlock.RF.NobleElite") == null) continue;

				while (nobleBlock.__DynamicSpawnables.len() > maxEliteTypes)
				{
					::MSU.Array.removeByValue(nobleBlock.__DynamicSpawnables, ::MSU.Array.rand(nobleBlock.__DynamicSpawnables));
				}
				break;
			}
		},
	},
	{
		ID = "NobleCaravan",
		HardMin = 9,
		DefaultFigure = "cart_01",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		UpgradeChance = 0.50,
		StaticDefs = {
			Units = [
				"Unit.RF.NobleCaravanDonkey",	// Makes it much easier to get a good ratio
			],
		},
		DynamicDefs = {
			UnitBlocks = [
				{ BaseID = "UnitBlock.RF.NobleFrontline", RatioMin = 0.40, RatioMax = 1.00, DeterminesFigure = false },		// Reforged: RatioMax = 0.6
				{ BaseID = "UnitBlock.RF.NobleBackline", RatioMin = 0.00, RatioMax = 0.40, DeterminesFigure = false, ExclusionChance = 0.2 },
				{ BaseID = "UnitBlock.RF.NobleRanged", RatioMin = 0.10, RatioMax = 0.30, DeterminesFigure = false },
				{ BaseID = "UnitBlock.RF.NobleElite", RatioMin = 0.00, RatioMax = 0.40, PartySizeMin = 13, DeterminesFigure = false, ExclusionChance = 0.2 },
				{ BaseID = "UnitBlock.RF.NobleOfficer", RatioMin = 1.0, PartySizeMin = 13, HardMax = 1, ExclusionChance = 0.5, DeterminesFigure = false, function canUpgrade() { return false; } },  // Vanilla: spawns at 12, at 15 and at 18 once respectively
				{ BaseID = "UnitBlock.RF.NobleDonkey", RatioMin = 1.0, PartySizeMin = 15, HardMax = 1 },	// Vanilla: second donkey spawns at 14+
			],
		},
	},
];

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
