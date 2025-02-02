::Hardened.HooksMod.hook("scripts/retinue/followers/scout_follower", function(q) {
	q.m.TerrainTypeSpeedMult <- 1.2;
	q.m.TerrainTypeVisionMult <- 1.25;

	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[0] = "Travel " + ::MSU.Text.colorizeMult(this.m.TerrainTypeSpeedMult) + " faster through Forests and Swamps";
		this.m.Effects.insert(1, ::MSU.Text.colorizeMultWithText(this.m.TerrainTypeVisionMult) + " Vision while on a Hill or Mountain");
	}

	// Overwrite because we replace the original movement speed effect
	q.onUpdate = @() function()
	{
		// More Speed in Forests and Swamps
		::World.Assets.m.TerrainTypeSpeedMult[::Const.World.TerrainType.Forest] *= this.m.TerrainTypeSpeedMult;
		::World.Assets.m.TerrainTypeSpeedMult[::Const.World.TerrainType.SnowyForest] *= this.m.TerrainTypeSpeedMult;
		::World.Assets.m.TerrainTypeSpeedMult[::Const.World.TerrainType.LeaveForest] *= this.m.TerrainTypeSpeedMult;
		::World.Assets.m.TerrainTypeSpeedMult[::Const.World.TerrainType.AutumnForest] *= this.m.TerrainTypeSpeedMult;
		::World.Assets.m.TerrainTypeSpeedMult[::Const.World.TerrainType.Swamp] *= this.m.TerrainTypeSpeedMult;

		// More Vision in Mountains and Hills
		::World.Assets.m.TerrainTypeVisionMult[::Const.World.TerrainType.Hills] *= this.m.TerrainTypeVisionMult;
		::World.Assets.m.TerrainTypeVisionMult[::Const.World.TerrainType.Mountains] *= this.m.TerrainTypeVisionMult;
	}
});
