::Reforged.Spawns.Parties["NobleCaravan"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Nobles * ::Hardened.Global.PartySizeMult.Caravan;

local parties = [
	{
		// Changes:
		//	- Dogs stop spawning at Party size of 20
		//	- Support has 0.2 ExclusionChance (up from 0.05)
		//	- Officer is restricted to 1
		ID = "Noble",
		HardMin = 8,
		IdealSizeMult = ::Hardened.Global.FactionIdealSizeMult.Nobles,
		DefaultFigure = "figure_noble_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		DynamicDefs = {
			UnitBlocks = [
				{ BaseID = "UnitBlock.RF.NobleFrontline", RatioMin = 0.30, RatioMax = 1.00 },
				{ BaseID = "UnitBlock.RF.NobleBackline", RatioMax = 0.30 },
				{ BaseID = "UnitBlock.RF.NobleRanged", RatioMax = 0.25, ExclusionChance = 20 },
				{ BaseID = "UnitBlock.RF.NobleElite",  RatioMin = 0.1, RatioMax = 0.25, PartySizeMin = 15, ExclusionChance = 20 }, // vanilla greatswords spawn at 19+
				{ BaseID = "UnitBlock.RF.NobleSupport", RatioMin = 1.0, HardMax = 1, PartySizeMin = 10, ExclusionChance = 40 },
				{ BaseID = "UnitBlock.RF.NobleOfficer", RatioMin = 1.0, HardMax = 1,  PartySizeMin = 15, ExclusionChance = 50 }, // vanilla sergeants spawn at 8+
				{ BaseID = "UnitBlock.RF.NobleLeader", RatioMax = 0.15, PartySizeMin = 12 }, // vanilla knights spawn at 18+
				{ BaseID = "UnitBlock.RF.NobleFlank", RatioMax = 0.25, HardMax = 3, ExclusionChance = 40, PartySizeMax = 15 },		// dogs only spawn in smaller parties
			],
		},

		function getIdealSizeMult() {
			local ret = base.getIdealSizeMult();
			if (this.getTopParty().HD_isLocation()) ret *= ::Hardened.Global.PartySizeMult.Location;
			return ret;
		},

		function excludeSpawnables()
		{
			local unitIDs = [];
			local obj = this.getSpawnable("UnitBlock.RF.NobleElite");
			if (obj != null)
			{
				foreach (spawnable in obj.__DynamicSpawnables)
				{
					unitIDs.push(spawnable.getID());
				}
			}

			base.excludeSpawnables();

			::Hardened.util.enforceFlexSpawnable(this, unitIDs, 2);		// We make sure, that no noble party contains more than this many elites at the same time

			local unitBlockIDs = ["UnitBlock.RF.NobleSupport", "UnitBlock.RF.NobleOfficer", "UnitBlock.RF.NobleLeader"];
			::Hardened.util.enforceFlexSpawnable(this, unitBlockIDs, 2);
		},
	},
	{
		ID = "NobleCaravan",
		HardMin = 9,
		DefaultFigure = "cart_01",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		StaticDefs = {
			Units = [
				"Unit.RF.NobleCaravanDonkey",	// Makes it much easier to get a good ratio
			],
		},
		DynamicDefs = {
			UnitBlocks = [
				{ BaseID = "UnitBlock.RF.NobleFrontline", RatioMin = 0.40, RatioMax = 1.00, DeterminesFigure = false },		// Reforged: RatioMax = 0.6
				{ BaseID = "UnitBlock.RF.NobleBackline", RatioMin = 0.00, RatioMax = 0.40, DeterminesFigure = false, ExclusionChance = 20 },
				{ BaseID = "UnitBlock.RF.NobleElite", RatioMin = 0.00, RatioMax = 0.40, PartySizeMin = 13, DeterminesFigure = false, ExclusionChance = 20 },
				{ BaseID = "UnitBlock.RF.NobleRanged", RatioMin = 0.0, RatioMax = 0.30, DeterminesFigure = false },
				{ BaseID = "UnitBlock.RF.NobleOfficer", RatioMin = 1.0, PartySizeMin = 13, HardMax = 1, ExclusionChance = 50, DeterminesFigure = false, function canUpgrade() { return false; } },  // Vanilla: spawns at 12, at 15 and at 18 once respectively
				{ BaseID = "UnitBlock.RF.NobleDonkey", RatioMin = 1.0, PartySizeMin = 15, HardMax = 1 },
			],
		},
	},
];

foreach(partyDef in parties)
{
	::Reforged.Spawns.Parties[partyDef.ID] <- partyDef;
}
