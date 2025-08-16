::Hardened.HooksMod.hook("scripts/retinue/followers/scout_follower", function(q) {
	q.m.TerrainTypeSpeedMult <- 1.2;
	q.m.TerrainTypeVisionMult <- 1.25;

	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[0] = "Travel 20% faster through Forests and Swamps";
		this.m.Effects.insert(1, "25% more Vision while on a Hill or Mountain");
	}

	// Overwrite because we replace the original effect
	q.onUpdate = @() function()
	{
		// More Vision in Mountains and Hills
		::World.Assets.m.TerrainTypeVisionMult[::Const.World.TerrainType.Hills] *= this.m.TerrainTypeVisionMult;
		::World.Assets.m.TerrainTypeVisionMult[::Const.World.TerrainType.Mountains] *= this.m.TerrainTypeVisionMult;
	}

// MSU Functions
	// Overwrite because we replace the original movement speed effect
	q.getMovementSpeedMult = @() function()
	{
		switch (::World.State.getPlayer().getTile().Type)
		{
			case ::Const.World.TerrainType.Forest:
			case ::Const.World.TerrainType.SnowyForest:
			case ::Const.World.TerrainType.LeaveForest:
			case ::Const.World.TerrainType.AutumnForest:
			case ::Const.World.TerrainType.Swamp:
			{
				return this.m.TerrainTypeSpeedMult;
			}
		}

		return 1.0;
	}
});
