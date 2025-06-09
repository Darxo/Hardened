::Hardened.HooksMod.hook("scripts/ui/screens/world/world_combat_dialog", function(q) {
	q.hide = @(__original) function()
	{
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
});
