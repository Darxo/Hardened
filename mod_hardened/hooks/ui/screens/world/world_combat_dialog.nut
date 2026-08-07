::Hardened.HooksMod.hook("scripts/ui/screens/world/world_combat_dialog", function(q) {
// Private
	q.m.HD_forceAllowDialog <- false;	// Should the show() function ignore checks for animating and visible?
	q.m.HD_isHidingScreen <- false;		// Are we currently in the process of hiding the combat dialog?

	q.show = @(__original) function( _entities, _allyBanners, _enemyBanners, _allowDisengage, _allowFormationPicking, _text, _image, _disengageText = "Cancel" )
	{
		// Vanilla Fix: World Map invisible UI freeze when cancelling a combat dialog and getting attacked right after
		// Hiding the combat dialog (via hide()) takes a little time, during which this class counts as animating/visible
		// If during that time show() is called, then the show window will not appear
		// All calls this this.show come from showCombatDialog, which creates a MenuStack no matter what
		// This menu stack will later freeze the world map, because the window that is means to be visible, was never shown
		// 	In Vanilla this bug does not happen, because cancelling a combat dialog always stuns nearby enemies
		// We fix this, by force-allowing this.show, if our window is still in the process of hiding
		// And later on the .js side, we make sure that any previous animation is cleaned up, before initiating the show animation
		if (this.m.HD_isHidingScreen) this.m.HD_forceAllowDialog = true;
		__original(_entities, _allyBanners, _enemyBanners, _allowDisengage, _allowFormationPicking, _text, _image, _disengageText);
		this.m.HD_forceAllowDialog = false;
	}

	q.isVisible = @(__original) function()
	{
		if (this.m.HD_forceAllowDialog) return false;
		return __original();
	}

	q.isAnimating = @(__original) function()
	{
		if (this.m.HD_forceAllowDialog) return false;
		return __original();
	}

	q.hide = @(__original) function()
	{
		this.m.HD_isHidingScreen = true;
		__original();

		// Combat Dialogs are only hidden when their window is "popped" from the stack
		// This happens either, when the player cancels the dialog or when he accepts the combat
		// We only want to call our custom logic, when the player cancels the dialog
		if (::Hardened.getFunctionCaller(1) == "combat_dialog_module_onCancelPressed")	// 0 = "pop"
		{
			// If we had a temporary enemy at this point, we remove that flag from them now
			// Similar logic to faction_manager::onCombatFinished:
			foreach (faction in ::World.FactionManager.m.Factions)
			{
				if (faction != null) faction.setIsTemporaryEnemy(false);
			}
		}
	}

	q.onScreenHidden = @(__original) function()
	{
		__original();
		this.m.HD_isHidingScreen = false;
	}
});
