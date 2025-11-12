::Hardened.HooksMod.hook("scripts/states/tactical_state", function(q) {
	q.updateCursorAndTooltip = @(__original) function( _skillSelected = false )
	{
		if (!::Hardened.Private.IsPreviewingAttackWithHitChance) return __original(_skillSelected);

		// Whenever we hover over a tile, we update all hitchance overlays but hide the one of the tile are currently on
		// This prevents a Hardened bug, where the text label prevents you from actually targeting the tile with your attack
		// That bug can still happen from neighboring labels, when they grow too big from zooming out
		local hoveredTile = ::Tactical.getTile(::Tactical.screenToTile(::Cursor.getX(), ::Cursor.getY()));

		local idsToIgnore = [];
		if (!hoveredTile.IsEmpty && hoveredTile.IsOccupiedByActor)
		{
			idsToIgnore.push(hoveredTile.getEntity().getID());
		}

		local orientationOverlay = ::Tactical.State.m.TacticalScreen.getOrientationOverlayModule();
		orientationOverlay.HD_updateHitchanceOverlayPositions(idsToIgnore);

		__original(_skillSelected);
	}
});
