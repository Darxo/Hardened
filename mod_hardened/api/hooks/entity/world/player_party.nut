::Hardened.HooksMod.hook("scripts/entity/world/player_party", function(q) {
	q.getVisionRadius = @(__original) function()
	{
		return __original() * ::World.Assets.getTerrainTypeVisionMult(this.getTile().Type);
	}
});
