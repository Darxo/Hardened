::Hardened.Temp.LootAllItemsButtonPressed <- false;		// This is used to improve the

::Hardened.HooksMod.hook("scripts/ui/screens/tactical/tactical_combat_result_screen", function(q) {
	q.onLootAllItemsButtonPressed = @(__original) function()	// This is called during battle
	{
		::Hardened.Temp.LootAllItemsButtonPressed = true;
		__original();
		::Hardened.Temp.LootAllItemsButtonPressed = false;
	}
});
