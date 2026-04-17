// This needs to be in HookLast, because we need to apply our changes after ModularVanilla does its HookVeryLate changes to turn sequence bar
::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	// This needs to be hooked during VeryLate, because of a ModularVanilla Pseudo-Overwrite
	q.setActiveEntityCostsPreview = @(__original) function( _costsPreview )
	{
		__original(_costsPreview);

		if (!::Hardened.Mod.ModSettings.getSetting("DisplayHitchanceOverlays").getValue()) return;

		local activeEntity = this.getActiveEntity();
		if (activeEntity == null) return;
		if (!activeEntity.isPreviewing()) return;
		if (activeEntity.getPreviewMovement() == null) return;

		if (!::Hardened.util.willBeAttackedLeavingZoneOfControl(activeEntity)) return;

		// Feat: Display chance to dodge, when we preview movement while in zone of control
		::Hardened.Private.IsPreviewingAttackWithHitChance = true;

		// For moving out of zone of control as the player, we instead display the chance to dodge,
		// That way we can re-use the coloring logic on the js side
		activeEntity.m.HD_ChanceToBeHit = ::Math.round(::Hardened.util.getChancetoDodgeLeavingTile(activeEntity));

		::Tactical.State.m.TacticalScreen.getOrientationOverlayModule().HD_fullUpdateHitchanceOverlays();
	}

	q.resetActiveEntityCostsPreview = @(__original) function()
	{
		__original();

		::Hardened.Private.IsPreviewingAttackWithHitChance = false;

		// We turn off the ChanceToBeHit of all actors on the battlefield
		foreach (actor in ::Tactical.Entities.getAllInstancesAsArray())
		{
			actor.m.HD_ChanceToBeHit = null;
		}

		::Tactical.State.m.TacticalScreen.getOrientationOverlayModule().HD_fullUpdateHitchanceOverlays();
	}
});
