// Hooking
{
	local banditScouts = ::Reforged.Spawns.Parties["BanditScouts"];
	banditScouts.HardMin = 5;	// Reforged: 7

	local banditRoamer = ::Reforged.Spawns.Parties["BanditRoamers"];
	foreach (unitBlock in banditRoamer.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BanditDog")
		{
			// Increase the exclusion chance for dogs to make their inclusion rarer and more of a novelty
			unitBlock.ExclusionChance = 70;	// Reforged: 40
			break;
		}
	}

	local banditRaider = ::Reforged.Spawns.Parties["BanditRaiders"];
	foreach (unitBlock in banditRaider.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BanditElite")
		{
			unitBlock.RatioMax = 0.15;	// Reforged: 0.13
			unitBlock.StartingResourceMin = 400;	// Reforged: 320
		}
	}

	local banditDefenderParty = ::Reforged.Spawns.Parties["BanditDefenders"];
	foreach (unitBlock in banditDefenderParty.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BanditRanged")
		{
			unitBlock.RatioMax = 0.25;	// Reforged: 0.55
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
	})
	// We make sure, that every camp only contains either Fast or Tough Bandits
	banditDefenderParty.excludeSpawnables <- function() {
		base.excludeSpawnables();

		local flexBlocks = [];
		foreach (index, banditBlock in this.__DynamicSpawnables)
		{
			if (banditBlock.getID().find("UnitBlock.RF.BanditFast") != null) flexBlocks.push(index);
			if (banditBlock.getID().find("UnitBlock.RF.BanditTough") != null) flexBlocks.push(index);
		}

		// We remove a single flex block, if there are too many
		// This approach does not work when removing multiple flex blocks, because __DynamicSpawnables order becomes undefined after the first removal of an array value
		if (flexBlocks.len() > 1)
		{
			local unitBlockIndexToRemove = flexBlocks.remove(::Math.rand(0, flexBlocks.len() - 1));
			this.__DynamicSpawnables.remove(unitBlockIndexToRemove);
		}
	};

	// We make sure, that no roaming party contains 3 "flex" groups
	foreach (banditPartyID in ["BanditRoamers", "BanditScouts", "BanditRaiders", "BanditBoss"])
	{
		// Todo: Adjust this hook after Dynamic Spawns Update is out
		::Reforged.Spawns.Parties[banditPartyID].excludeSpawnables <- function() {
			base.excludeSpawnables();

			local flexBlocks = [];
			foreach (index, banditBlock in this.__DynamicSpawnables)
			{
				if (banditBlock.getID().find("UnitBlock.RF.BanditFast") != null) flexBlocks.push(index);
				if (banditBlock.getID().find("UnitBlock.RF.BanditTough") != null) flexBlocks.push(index);
				if (banditBlock.getID().find("UnitBlock.RF.BanditRanged") != null) flexBlocks.push(index);
			}

			// We remove a single flex block, if there are too many
			// This approach does not work when removing multiple flex blocks, because __DynamicSpawnables order becomes undefined after the first removal of an array value
			if (flexBlocks.len() > 2)
			{
				local unitBlockIndexToRemove = flexBlocks.remove(::Math.rand(0, flexBlocks.len() - 1));
				this.__DynamicSpawnables.remove(unitBlockIndexToRemove);
			}
		};
	}
}
