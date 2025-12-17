// Overwrites
{
	local parties = [
		{
			ID = "CaravanSouthern",
			HardMin = 4,
			DefaultFigure = "cart_03",
			MovementSpeedMult = 0.5,
			VisibilityMult = 1.0,
			VisionMult = 0.25,
			StaticDefs = {
				Units = [
					{ BaseID = "Unit.RF.SouthernDonkey" },
				],
			},
			DynamicDefs = {
				UnitBlocks = [
					{ BaseID = "UnitBlock.RF.SouthernFrontline", RatioMin = 0.15, RatioMax = 1.00, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.SouthernBackline", RatioMin = 0.10, RatioMax = 0.40, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.Officer", RatioMin = 0.00, RatioMax = 0.08, PartySizeMin = 10, DeterminesFigure = false },
					{ BaseID = "UnitBlock.RF.SouthernCaravanDonkey", RatioMin = 0.01, RatioMax = 0.12, PartySizeMin = 12 },	// Vanilla: Second starts spawning at 14, then 16+

					// Flex-Block: Only one of these can appear at the same time, as decided by our excludeSpawnables hook
					{ BaseID = "UnitBlock.RF.Slave", HardMin = 2, RatioMax = 0.25, DeterminesFigure = false },
					{ BaseID = "UnitBlock.HD.Gladiators", HardMin = 2, StartingResourceMin = 200, RatioMax = 0.25, DeterminesFigure = false },
				],
			},

			excludeSpawnables = function()
			{
				base.excludeSpawnables();

				local flexBlockPossibilities = ::MSU.Class.WeightedContainer([
					[60, "UnitBlock.RF.Slave"],
					[10, "UnitBlock.HD.Gladiators"],
					[30, "None"],
				]);

				local chosenBlock = flexBlockPossibilities.roll();
				foreach (option in flexBlockPossibilities.toArray())
				{
					if (option == chosenBlock) continue;

					foreach (index, southernBlock in this.__DynamicSpawnables)
					{
						if (southernBlock.getID().find(option) != null)
						{
							this.__DynamicSpawnables.remove(index);
							break;
						}
					}
				}
			},
			// In Vanilla this party is also able to spawn just with mercenaries. But this is so rare that I chose to not try to mirror that behavior here
		},
	];

	foreach(partyDef in parties)
	{
		::DynamicSpawns.Public.registerParty(partyDef);
	}
}
