// Hooking
{
	local undeadArmyParty = ::Reforged.Spawns.Parties["UndeadArmy"];
	undeadArmyParty.Variants.filter(function(_item, _weight) {
		_item.IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Skeletons;
		_item.getIdealSizeMult <- function() {
			local ret = base.getIdealSizeMult();
			if (this.getTopParty().HD_isLocation()) ret *= ::Hardened.Global.PartySizeMult.Location;
			return ret;
		};

		if (_item.ID == "UndeadArmy_0")
		{
			_item.HardMin = 6;	// Reforged: 10
			foreach (unitBlock in _item.DynamicDefs.UnitBlocks)
			{
				if (unitBlock.BaseID == "UnitBlock.RF.SkeletonDecanus" || unitBlock.BaseID == "UnitBlock.RF.SkeletonCenturion" || unitBlock.BaseID == "UnitBlock.RF.SkeletonLegatus")
				{
					unitBlock.HardMax = 1;
					unitBlock.ExclusionChance <- 90;
				}
			}

			// Necromancer parties can sometimes throw in a random extra necromancer
			_item.DynamicDefs.UnitBlocks.push({
				BaseID = "UnitBlock.HD.SkeletonLeader",
				PartySizeMin = 6,
				ExclusionChance = 30,
				HardMin = 0,
				HardMax = 1,
			});
		}
	});

	local vampiresAndSkeletonsParty = ::Reforged.Spawns.Parties["VampiresAndSkeletons"];
	vampiresAndSkeletonsParty.Variants.filter(function(_item, _weight) {
		_item.IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Skeletons;
		_item.getIdealSizeMult <- function() {
			local ret = base.getIdealSizeMult();
			if (this.getTopParty().HD_isLocation()) ret *= ::Hardened.Global.PartySizeMult.Location;
			return ret;
		};

		if (_item.ID == "VampiresAndSkeletons_0")
		{
			foreach (unitBlock in _item.DynamicDefs.UnitBlocks)
			{
				if (unitBlock.BaseID == "UnitBlock.RF.SkeletonDecanus" || unitBlock.BaseID == "UnitBlock.RF.SkeletonCenturion" || unitBlock.BaseID == "UnitBlock.RF.SkeletonLegatus")
				{
					unitBlock.HardMax = 1;
					unitBlock.ExclusionChance <- 90;
				}
			}

			// Necromancer parties can sometimes throw in a random extra necromancer
			_item.DynamicDefs.UnitBlocks.push({
				BaseID = "UnitBlock.HD.SkeletonLeader",
				PartySizeMin = 6,
				ExclusionChance = 30,
				HardMin = 0,
				HardMax = 1,
			});
		}
	});

	local vampiresParty = ::Reforged.Spawns.Parties["Vampires"];
	vampiresParty.IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Vampires;
	vampiresParty.getIdealSizeMult <- function() {
		local ret = base.getIdealSizeMult();
		if (this.getTopParty().HD_isLocation()) ret *= ::Hardened.Global.PartySizeMult.Location;
		return ret;
	};
}
