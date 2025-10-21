
// Hooking
{
	foreach (unitBlock in ::DynamicSpawns.Public.getParty("BanditRoamers").DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BanditDog")
		{
			// Increase the exclusion chance for dogs but garuantee a certain amount of them, to make their inclusion rarer and more of a novelty
			unitBlock.ExclusionChance = 0.7;	// Reforged: 0.1
			unitBlock.RatioMin = 0.08;			// Reforged: 0.0
			break;
		}
	}

	foreach (unitBlock in ::DynamicSpawns.Public.getParty("BanditRaiders").DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BanditBoss" && "StartingResourceMin" in unitBlock)
		{
			// We lower the Resource Requirement for Leader because we add a new lower tier leader unit
			unitBlock.StartingResourceMin = 180;	// In Reforged this is 250
			break;
		}
	}

	local banditDefenderParty = ::DynamicSpawns.Public.getParty("BanditDefenders");
	foreach (unitBlock in banditDefenderParty.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.BanditBoss" && "StartingResourceMin" in unitBlock)
		{
			// We lower the Resource Requirement for Leader because we add a new lower tier leader unit
			unitBlock.StartingResourceMin = 180;	// In Reforged this is 250
			break;
		}
	}
	// We make sure, that every camp only contains either Fast or Tough Bandits
	banditDefenderParty.Class.onBeforeSpawnStart <- function() {
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
		::DynamicSpawns.Public.getParty(banditPartyID).Class.onBeforeSpawnStart <- function() {
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

