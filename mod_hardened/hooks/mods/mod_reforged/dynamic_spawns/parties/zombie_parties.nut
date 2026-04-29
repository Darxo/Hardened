// Hooking
{
	::Reforged.Spawns.Parties["ZombieOrcs"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs;
	::Reforged.Spawns.Parties["Zombies"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Zombies;
	::Reforged.Spawns.Parties["ZombiesAndGhouls"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Zombies;
	::Reforged.Spawns.Parties["ZombiesAndGhosts"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Zombies;

	local necromancerParty = ::Reforged.Spawns.Parties["Necromancer"];
	necromancerParty.Variants.filter(function(_item, _weight) {
		_item.IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Zombies;
		if (_item.ID == "Necromancer_0")
		{
			_item.HardMin = 6;	// Reforged: 10
			foreach (unitBlock in _item.DynamicDefs.UnitBlocks)
			{
				if (unitBlock.BaseID == "UnitBlock.RF.Ghost")
				{
					unitBlock.PartySizeMin <- 7;
				}
				else if (unitBlock.BaseID == "UnitBlock.RF.NecromancerWithBodyguards")
				{
					delete unitBlock["onBeforeSpawnStart"];		// HardMin and HardMax is no longer decided by Resources and restricted to max 2
					unitBlock.HardMin <- 1;	// We guarantee one necromancer, because of how this party is expected to work
					unitBlock.RatioMin <- 0.0;	// Refroged: 0.0
					unitBlock.RatioMax <- 0.1;	// Reforged: 1.0
				}
			}
			// Necromancer parties can sometimes throw in a random extra necromancer
			_item.DynamicDefs.UnitBlocks.push({
				BaseID = "UnitBlock.RF.NecromancerWithBodyguards",
				PartySizeMin = 15,
				ExclusionChance = 80,
				HardMin = 1,
				HardMax = 1,
			});
		}
	});

	local necromancerSouthernParty = ::Reforged.Spawns.Parties["NecromancerSouthern"];
	necromancerSouthernParty.Variants.filter(function(_item, _weight) {
		_item.IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Zombies;
	});
}
