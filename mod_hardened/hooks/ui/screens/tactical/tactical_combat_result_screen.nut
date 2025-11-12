// This is used to fix an issue with the vanilla onLootAllItemsButtonPressed
// Vanilla first adds an item to your inventory, and afterwards sometimes tries to access that same index again trying to play an inventory sound
// But if my tools/money etc. would vanish instantly here, during autoloot, then the looting would crash, trying to access null
::Hardened.Temp.LootAllItemsButtonPressed <- false;

::Hardened.HooksMod.hook("scripts/ui/screens/tactical/tactical_combat_result_screen", function(q) {
	q.onLootAllItemsButtonPressed = @(__original) function()	// This is called during battle
	{
		::Hardened.Temp.LootAllItemsButtonPressed = true;
		local ret = __original();
		::Hardened.Temp.LootAllItemsButtonPressed = false;
		return ret;
	}
});
