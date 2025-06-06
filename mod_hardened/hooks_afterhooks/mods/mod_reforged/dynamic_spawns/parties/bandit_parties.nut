foreach (unitBlock in ::DynamicSpawns.Public.getParty("BanditRaiders").DynamicDefs.UnitBlocks)
{
	if (unitBlock.BaseID == "UnitBlock.RF.BanditBoss" && "StartingResourceMin" in unitBlock)
	{
		// We lower the Resource Requirement for Leader because we add a new lower tier leader unit
		unitBlock.StartingResourceMin = 180;	// In Reforged this is 250
		break;
	}
}

foreach (unitBlock in ::DynamicSpawns.Public.getParty("BanditDefenders").DynamicDefs.UnitBlocks)
{
	if (unitBlock.BaseID == "UnitBlock.RF.BanditBoss" && "StartingResourceMin" in unitBlock)
	{
		// We lower the Resource Requirement for Leader because we add a new lower tier leader unit
		unitBlock.StartingResourceMin = 180;	// In Reforged this is 250
		break;
	}
}

// We make sure, that every camp only contains either Fast or Tough Bandits
local banditDefenderParty = ::DynamicSpawns.Public.getParty("BanditDefenders");
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
