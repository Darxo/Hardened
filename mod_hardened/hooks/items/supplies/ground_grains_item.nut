::Hardened.HooksMod.hook("scripts/items/supplies/ground_grains_item", function(q) {
	q.isBuildingPresent = @(__original) function( _settlement )
	{
		// We define Ground Grain as home to any northern (snowy) or neutral (middle section) settlements
		local culture = ::World.State.getCurrentTown().getCulture();
		return culture == ::Const.World.Culture.Northern || culture == ::Const.World.Culture.Neutral;
	}
});
