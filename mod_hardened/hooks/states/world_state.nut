::Hardened.HooksMod.hook("scripts/states/world_state", function(q) {
	q.updateTopbarAssets = @(__original) function()		// In Vanilla this triggers once per hour
	{
		__original();

		local playerTile = this.getPlayer().getTile();
		local distanceCutoff = ::Hardened.Mod.ModSettings.getSetting("DistanceForLocationName").getValue();
		if (distanceCutoff <= 0) return;	// Setting this to 0 will save a lot of performance if the player does not want this feature.

		local allAdditionalType = ::Const.World.LocationType.Lair | ::Const.World.LocationType.Unique | ::Const.World.LocationType.AttachedLocation;
		local locationTypesToDisplay = 0;
		if (::Hardened.Mod.ModSettings.getSetting("DisplayCampLocationsNames").getValue()) locationTypesToDisplay += ::Const.World.LocationType.Lair;
		if (::Hardened.Mod.ModSettings.getSetting("DisplayUniqueLocationsNames").getValue()) locationTypesToDisplay += ::Const.World.LocationType.Unique;
		if (::Hardened.Mod.ModSettings.getSetting("DisplayAttachedLocationNames").getValue()) locationTypesToDisplay += ::Const.World.LocationType.AttachedLocation;

		foreach (location in ::World.EntityManager.getLocations())
		{
			if (!location.isLocationType(allAdditionalType)) continue;

			if (location.isLocationType(locationTypesToDisplay) && playerTile.getDistanceTo(location.getTile()) <= distanceCutoff)
			{
				location.m.TemporarilyShowingName = true;
				location.setShowName(true);
			}
			else
			{
				if (location.m.TemporarilyShowingName)
				{
					location.m.TemporarilyShowingName = false;
					location.setShowName(false);
				}
			}
		}
	}

	q.loadCampaign = @(__original) function( _campaignFileName )
	{
		__original(_campaignFileName);

		// Force Update all parties on the world map once so that they VisibilityMult correctly reflects things like Terrain or Invisibility (Alps)
		this.getPlayer().setAttackable(false);	// We don't want to immediately get attacked during the loading screen. Todo: though eventually we want that to be a possability to retain the engagement state after loading
		foreach (worldParty in ::World.getAllEntitiesAtPos(this.getPlayer().getPos(), 2000))
		{
			worldParty.onUpdate();
		}
		this.getPlayer().setAttackable(true);

		// These two lines in combination will force reveal all enemies that the player should be able to see. They fix the bug where you don't see enemies when loading a game
		::World.setPlayerPos(this.getPlayer().getPos());
		::World.setPlayerVisionRadius(this.getPlayer().getVisionRadius());
	}

	// Cheese Fix: Prevent Perma-Stunning World Parties
	q.stunPartiesNearPlayer = @(__original) function( _isMinor = false )
	{
		if (::Hardened.getFunctionCaller(1) == "combat_dialog_module_onCancelPressed")	// 0 = "pop"
		{
			return;	// Cancelling the combat menu no longer stuns nearby parties
		}

		__original(_isMinor);
	}
});
