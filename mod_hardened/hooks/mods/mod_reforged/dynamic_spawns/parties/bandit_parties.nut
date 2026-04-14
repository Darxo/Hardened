// Hooking
{
	local banditScouts = ::Reforged.Spawns.Parties["BanditScouts"];
	banditScouts.HardMin = 5;	// Reforged: 6

	{	// BanditRoamers
		local banditRoamer = ::Reforged.Spawns.Parties["BanditRoamers"];
		foreach (unitBlock in banditRoamer.DynamicDefs.UnitBlocks)
		{
			if (unitBlock.BaseID == "UnitBlock.RF.BanditDog")
			{
				// Increase the exclusion chance for dogs to make their inclusion rarer and more of a novelty
				unitBlock.ExclusionChance = 70;	// Reforged: 40
			}
		}
	}

	{	// BanditRaiders
		local banditRaider = ::Reforged.Spawns.Parties["BanditRaiders"];
		foreach (unitBlock in banditRaider.DynamicDefs.UnitBlocks)
		{
			if (unitBlock.BaseID == "UnitBlock.RF.BanditElite")
			{
				unitBlock.RatioMax = 0.15;	// Reforged: 0.13
				unitBlock.StartingResourceMin = 400;	// Reforged: 320
			}
		}
	}

	{	// BanditDefenders
		local banditDefenderParty = ::Reforged.Spawns.Parties["BanditDefenders"];
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
