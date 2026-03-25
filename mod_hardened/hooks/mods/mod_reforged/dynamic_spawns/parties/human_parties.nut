// Hooking
{
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
			unitBlock.StartingResourceMin = 250;	// Reforged: 130
			break;
		}
	}

	local caravanParty = ::Reforged.Spawns.Parties["Caravan"];
	caravanParty.Variants.filter(function(_item, _weight) {
		if (_item.ID == "Caravan_0")
		{
			foreach (unitBlock in _item.DynamicDefs.UnitBlocks)
			{
				if (unitBlock.BaseID == "UnitBlock.RF.CaravanDonkey")
				{
					unitBlock.RatioMin = 0.15;		// Reforged: 0.17
					unitBlock.RatioMax = 0.25;		// Reforged: 0.2
				}
				else if (unitBlock.BaseID == "UnitBlock.RF.CaravanHand")
				{
					unitBlock.RatioMin = 0.1;		// Reforged: 0.35
					unitBlock.RatioMax = 0.20;		// Reforged: 0.8
				}
				else if (unitBlock.BaseID == "UnitBlock.RF.CaravanGuard")
				{
					unitBlock.RatioMin = 0.2;		// Reforged: 0.15
					unitBlock.RatioMax = 1.0;		// Reforged: 0.55
				}
			}
			_item.generateIdealSize <- function()
			{
				return 6;	// Caravans want to be small and not dynamically larger depending on player party
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
