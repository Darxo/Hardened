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

		::Hardened.Private.IsPreviewingAttackWithHitChance = true;

		local expectedChanceToDodge = null;
		foreach (tile in ::MSU.Tile.getNeighbors(activeEntity.getTile()))
		{
			if (!tile.IsOccupiedByActor) continue;
			if (!tile.getEntity().onMovementInZoneOfControl(activeEntity, false)) continue;		// The entity in that tile does not exert zone of control onto us

			local aooSkill = tile.getEntity().getSkills().getAttackOfOpportunity();
			if (!aooSkill.onVerifyTarget(tile, activeEntity.getTile())) continue;	// The aooSkill found can actually hit us (this will cover cases of tile height difference being too large)

			local chanceToBeHit = aooSkill.getHitchance(activeEntity);
			if (expectedChanceToDodge == null)
			{
				expectedChanceToDodge = 100.0 - chanceToBeHit;
			}
			else
			{
				expectedChanceToDodge *= (100.0 - chanceToBeHit) / 100.0;
			}
		}
		if (expectedChanceToDodge == null) return;

		// For moving out of zone of control as the player, we instead display the chance to dodge,
		// That way we can re-use the coloring logic on the js side
		activeEntity.m.HD_ChanceToBeHit = ::Math.round(expectedChanceToDodge);

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
