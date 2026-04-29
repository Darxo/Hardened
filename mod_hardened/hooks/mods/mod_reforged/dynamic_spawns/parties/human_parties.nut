// Hooking
{
	::Reforged.Spawns.Parties["Cultists"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Civilians;
	::Reforged.Spawns.Parties["Peasants"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Civilians * ::Hardened.Global.PartySizeMult.Caravan;
	::Reforged.Spawns.Parties["PeasantsArmed"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Civilians;
	::Reforged.Spawns.Parties["PeasantsSouthern"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Civilians * ::Hardened.Global.PartySizeMult.Caravan;
	::Reforged.Spawns.Parties["BountyHunters"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Mercenaries;
	::Reforged.Spawns.Parties["Mercenaries"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Mercenaries;
	::Reforged.Spawns.Parties["Militia"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Militia;
	::Reforged.Spawns.Parties["CaravanEscort"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Civilians * ::Hardened.Global.PartySizeMult.Caravan;

	local mercParty = ::Reforged.Spawns.Parties["Mercenaries"];
	mercParty.HardMin = 6;	// Reforged: 8
	foreach (unitBlock in mercParty.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.Wardog")
		{
			unitBlock.ExclusionChance <- 0.4;	// Reforged: 0.0
			unitBlock.HardMax <- 4;		// Reforged: unlimited
			break;
		}
	}

	local militiaParty = ::Reforged.Spawns.Parties["Militia"];
	foreach (unitBlock in militiaParty.DynamicDefs.UnitBlocks)
	{
		if (unitBlock.BaseID == "UnitBlock.RF.MilitiaCaptain")
		{
			unitBlock.StartingResourceMin = 200;	// Reforged: 130
			break;
		}
	}

	local caravanParty = ::Reforged.Spawns.Parties["Caravan"];
	caravanParty.Variants.filter(function(_item, _weight) {
		_item.IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Civilians * ::Hardened.Global.PartySizeMult.Caravan;
		if (_item.ID == "Caravan_0")
		{
			foreach (unitBlock in _item.DynamicDefs.UnitBlocks)
			{
				if (unitBlock.BaseID == "UnitBlock.RF.CaravanDonkey")
				{
					unitBlock.RatioMax = 0.2;		// Reforged: 0.1
				}
				else if (unitBlock.BaseID == "UnitBlock.RF.CaravanHand")
				{
					// We reduce the amount of caravan hands, because they now also exist as the lowest tier of the CaravanGuards
					unitBlock.RatioMin = 0.05;		// Reforged: 0.35
					unitBlock.RatioMax = 0.15;		// Reforged: 0.8
				}
				else if (unitBlock.BaseID == "UnitBlock.RF.CaravanGuard")
				{
					unitBlock.RatioMin = 0.2;		// Reforged: 0.15
					unitBlock.RatioMax = 1.0;		// Reforged: 0.6
					delete unitBlock.getSpawnWeight;
				}
			}
		}
		else if (_item.ID == "Caravan_1")
		{
			// We set the weight of the second caravan variant to 0, as we never want it to appear
			caravanParty.Variants.setWeight(_item, 0);		// Reforged: 1
		}
	});
}

// Overwriting
{
}
