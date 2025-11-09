// New Blocks
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
