::Hardened.HooksMod.hook("scripts/items/supplies/dried_fish_item", function(q) {
// Hardened Functions
	q.isBuildingPresent = @(__original) function( _settlement )
	{
		return __original(_settlement) || _settlement.hasAttachedLocation("attached_location.harbor");	// This is vanilla behavior in that vanilla makes dried fish cheaper in presence of a harbor
	}
});
