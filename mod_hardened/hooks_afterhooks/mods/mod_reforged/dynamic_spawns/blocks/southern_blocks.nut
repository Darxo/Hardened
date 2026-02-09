// The following blocks exist under mod_crock_pot in a specific version. In order to stay compatible with it, we use them in our parties and then add them
if (!::Hooks.hasMod("mod_crock_pot") || ::Hooks.getMod("mod_crock_pot").getVersion() <= ::Hooks.SQClass.ModVersion("0.5.3"))
{
	{	// New Blocks
		local unitBlocks = [
			{
				ID = "UnitBlock.CP.CaravanGuardSouthern",
				DynamicDefs = {
					Units = [
						{ BaseID = "Unit.RF.Conscript" },
						{ BaseID = "Unit.RF.Officer", HardMax = 1, PartySizeMin = 12, ExclusionChance = 0.5 }
					],
				}
			},
			{
				ID = "UnitBlock.CP.CaravanHandSouthern",
				DynamicDefs = {
					Units = [{ BaseID = "Unit.RF.Conscript" }],
				}
			},
		];

		foreach (blockDef in unitBlocks)
		{
			::DynamicSpawns.Public.registerUnitBlock(blockDef);
		}
	}
}

// New Blocks
{
	local unitBlocks = [
		{
			ID = "UnitBlock.HD.Gladiators",
			DynamicDefs = {
				Units = [{ BaseID = "Unit.HD.Gladiator" }],
			}
		},
	];

	foreach (blockDef in unitBlocks)
	{
		::DynamicSpawns.Public.registerUnitBlock(blockDef);
	}
}
