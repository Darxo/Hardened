// Hooking
{
	::Reforged.Spawns.Parties["BanditRoamers"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Brigands;
	::Reforged.Spawns.Parties["BanditScouts"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Brigands * ::Hardened.Global.PartySizeMult.Scouts;
	::Reforged.Spawns.Parties["BanditRaiders"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Brigands;
	::Reforged.Spawns.Parties["BanditDefenders"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Brigands * ::Hardened.Global.PartySizeMult.Location;
	::Reforged.Spawns.Parties["BanditBoss"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Brigands;
	::Reforged.Spawns.Parties["BanditsDisguisedAsDirewolves"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Brigands;

	local banditScouts = ::Reforged.Spawns.Parties["BanditScouts"];
	banditScouts.HardMin = 5;	// Reforged: 6

	{	// RF_BanditFrontline
		local banditFrontline = ::Reforged.Spawns.Parties["RF_BanditFrontline"];
		foreach (unitBlock in banditFrontline.DynamicDefs.UnitBlocks)
		{
			if (unitBlock.BaseID == "UnitBlock.RF.BanditFast") unitBlock.RatioMax = 0.35;	// Reforged: 0.5
			if (unitBlock.BaseID == "UnitBlock.RF.BanditTough") unitBlock.RatioMax = 0.35;	// Reforged: 0.5
		}
	}

	{	// BanditRoamers
		local banditRoamer = ::Reforged.Spawns.Parties["BanditRoamers"];

		// We overwrite the Reforged function to disable the dynamic ExclusionChance and Ratios for Ranged Units
		banditRoamer.onBeforeSpawnStart = function() { base.onBeforeSpawnStart(); }
	}

	{	// BanditRaiders
		local banditRaider = ::Reforged.Spawns.Parties["BanditRaiders"];

		// We overwrite the Reforged function to disable the dynamic ExclusionChance and Ratios for Ranged Units
		banditRaider.onBeforeSpawnStart = function() { base.onBeforeSpawnStart(); }

		foreach (unitBlock in banditRaider.DynamicDefs.UnitBlocks)
		{
			if (unitBlock.BaseID == "UnitBlock.RF.BanditRanged")
			{
				unitBlock.ExclusionChance <- 20;	// Reforged: 0
			}
			if (unitBlock.BaseID == "UnitBlock.RF.BanditElite")
			{
				unitBlock.RatioMax = 0.15;	// Reforged: 0.13
				unitBlock.StartingResourceMin = 400;	// Reforged: 320
			}
		}
	}

	{	// BanditDefenders
		local banditDefenderParty = ::Reforged.Spawns.Parties["BanditDefenders"];

		// We overwrite the Reforged function to disable the dynamic chances and values for many blocks
		banditDefenderParty.onBeforeSpawnStart = function() { base.onBeforeSpawnStart(); }

		foreach (unitBlock in banditDefenderParty.DynamicDefs.UnitBlocks)
		{
			if (unitBlock.BaseID == "UnitBlock.RF.BanditRanged")
			{
				unitBlock.RatioMax <- 0.25;	// Reforged: 0.55
				unitBlock.StartingResourceMin <- 150;
			}
			else if (unitBlock.BaseID == "UnitBlock.RF.BanditElite")
			{
				unitBlock.StartingResourceMin <- 400;
			}
		}
		// We add a new low-resource-only ranged block, that is much more freqently missing, so that you face pure frontline battles more often during the early game
		banditDefenderParty.DynamicDefs.UnitBlocks.push({
			BaseID = "UnitBlock.RF.BanditRanged",
			RatioMax = 0.25,
			ExclusionChance = 50,
			StartingResourceMax = 149,
		});
		// We make sure, that every camp only contains either Fast or Tough Bandits
		banditDefenderParty.excludeSpawnables <- function() {
			base.excludeSpawnables();

			local unitBlockIDs = ["UnitBlock.RF.BanditFast", "UnitBlock.RF.BanditTough", "UnitBlock.RF.BanditRanged"];
			::Hardened.util.enforceFlexSpawnable(this, unitBlockIDs, 1);
		};
	}

	{	// "BanditScouts", "BanditRaiders", "BanditBoss"
		// We make sure, that no roaming party contains more than 2 "flex" groups
		foreach (banditPartyID in ["BanditScouts", "BanditRaiders", "BanditBoss"])
		{
			// Todo: Adjust this hook after Dynamic Spawns Update is out
			::Reforged.Spawns.Parties[banditPartyID].excludeSpawnables <- function() {
				base.excludeSpawnables();

				local unitBlockIDs = ["UnitBlock.RF.BanditFast", "UnitBlock.RF.BanditTough", "UnitBlock.RF.BanditRanged"];
				::Hardened.util.enforceFlexSpawnable(this, unitBlockIDs, 2);
			};
		}
	}
}
