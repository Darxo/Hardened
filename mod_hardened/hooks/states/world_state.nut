::Hardened.HooksMod.hook("scripts/states/world_state", function(q) {
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
		local stackInfo = ::getstackinfos(4);	// 1 & 2 are "Unknown"; 3 == "pop"
		if (stackInfo != null && stackInfo.func == "combat_dialog_module_onCancelPressed")
		{
			return;	// Cancelling the combat menu no longer stuns nearby parties
		}

		__original(_isMinor);
	}
});
