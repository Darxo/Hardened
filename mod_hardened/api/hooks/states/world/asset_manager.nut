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
});
