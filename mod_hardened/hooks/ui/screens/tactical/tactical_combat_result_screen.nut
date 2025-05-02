::Hardened.Temp.LootAllItemsButtonPressed <- false;		// This is used to improve the

::Hardened.HooksMod.hook("scripts/ui/screens/tactical/tactical_combat_result_screen", function(q) {
	q.hide = @(__original) function()
	{
		// Vanilla Fix: Vanilla calls this during `onCombatFinished()`, but that timing is too early.
		// By that time none of the ground- or camp items have been looted. So dropped items will not be able to be restored correctly
		if (::Settings.getGameplaySettings().RestoreEquipment)
		{
			::World.Assets.restoreEquipment();
		}

		__original();
	}

	q.onLootAllItemsButtonPressed = @(__original) function()	// This is called during battle
	{
		::Hardened.Temp.LootAllItemsButtonPressed = true;
		local ret = __original();
		::Hardened.Temp.LootAllItemsButtonPressed = false;
		return ret;
	}
});
