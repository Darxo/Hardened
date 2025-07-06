::Hardened.HooksMod.hook("scripts/items/supplies/rice_item", function(q) {
	q.isBuildingPresent = @(__original) function( _settlement )
	{
		// We define Ground Grain as home to any southern settlements
		return ::World.State.getCurrentTown().getCulture() == ::Const.World.Culture.Southern;
	}
});
