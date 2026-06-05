// New Blocks
{
	local unitBlocks = [
		{
			ID = "UnitBlock.HD.SkeletonLeader",
			DynamicDefs = {
				Units = [{ BaseID = "Unit.RF.RF_SkeletonDecanus" }],
				Units = [{ BaseID = "Unit.RF.RF_SkeletonCenturion" }],
				Units = [{ BaseID = "Unit.RF.RF_SkeletonLegatus" }],
			}
		},
	];

	foreach (blockDef in unitBlocks)
	{
		::Reforged.Spawns.UnitBlocks[blockDef.ID] <- blockDef;
	}
}

{	// Hooks
	{	// UnitBlock.RF.SkeletonBackline
		local skeletonBackline = ::Reforged.Spawns.UnitBlocks["UnitBlock.RF.SkeletonBackline"];
		skeletonBackline.DynamicDefs.Units.push({ BaseID = "Unit.RF.SkeletonLight" });
	}
}
