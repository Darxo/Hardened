::Hardened.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.m.IsAlwaysShowingScoutingReport <- false;		// Same effect as Vanilla Poacher Origin
	q.m.TerrainTypeVisionMult <- [];

	q.create = @(__original) function()
	{
		__original();
		this.m.TerrainTypeVisionMult = array(::Const.World.TerrainFoodConsumption.len(), 1.0);
	}

	q.resetToDefaults = @(__original) function()
	{
		this.m.IsAlwaysShowingScoutingReport = false;
		this.m.TerrainTypeVisionMult = array(::Const.World.TerrainFoodConsumption.len(), 1.0);
		__original();
	}

// New Functions
	q.getTerrainTypeVisionMult <- function( _tileType )
	{
		return this.m.TerrainTypeVisionMult[_tileType];
	}

	// Return the maximum Ammo that the player can carry around
	q.HD_getAmmoMax <- function()
	{
		return ::Const.Difficulty.MaxResources[this.getEconomicDifficulty()].Ammo + this.m.AmmoMaxAdditional;
	}

	// Return the maximum Tools that the player can carry around
	q.HD_getArmorPartsMax <- function()
	{
		return ::Const.Difficulty.MaxResources[this.getEconomicDifficulty()].ArmorParts + this.m.ArmorPartsMaxAdditional;
	}

	// Return the maximum Medicine that the player can carry around
	q.HD_getMedicineMax <- function()
	{
		return ::Const.Difficulty.MaxResources[this.getEconomicDifficulty()].Medicine + this.m.MedicineMaxAdditional;
	}
});
