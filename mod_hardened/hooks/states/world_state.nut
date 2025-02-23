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

	// This Switcheroo Hook is tricky because Locations will spawn their entire defender lineup during this function if they haven't before.
	// And that will cause potentially cause several random Math.minf and Math.max calls
	// But that is ok, because what we are doing is very harmless to those calls. We only change the content of EngageEnemyNumbers and restore it afterwards
	q.showCombatDialog = @(__original) function( _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true, _properties = null, _pos = null )
	{
		local oldEngageEnemyNumbers = clone ::Const.Strings.EngageEnemyNumbers;

		// We must retrieve the original enemy troop amount, that we want to display the amount for
		// The only time that number is ever passed outside of 'getTroopComposition' is, when it's divided by 14 and passed to minf. So that's where we fetch it from
		// We decide that this is also the place, where we change, which string is shown to the player for this enemy amount, by changing the values of every single EngageEnemyNumbers entry to that
		local mockObjectMinf = ::Hardened.mockFunction(::Math, "minf", function( _first, _second ) {
			if (_first == 1.0)
			{
				local originalEnemyNumber = ::Math.round(_second * 14.0);	// the 14.0 is hard-coded and needs to be adjusted if vanilla changes it
				local newText = ::Hardened.Numerals.getNumeralString(originalEnemyNumber, false);
				foreach (index, entry in ::Const.Strings.EngageEnemyNumbers)
				{
					::Const.Strings.EngageEnemyNumbers[index] = newText;
				}
			}
		});

		local ret = __original(_isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking, _properties, _pos);

		local oldEngageEnemyNumbers = ::Const.Strings.EngageEnemyNumbers = oldEngageEnemyNumbers;
		mockObjectMinf.cleanup();

		return ret;
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
