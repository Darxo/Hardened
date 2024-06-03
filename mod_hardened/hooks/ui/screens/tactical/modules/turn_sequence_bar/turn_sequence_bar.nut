::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.isRemovingEntity = @() function()	// This is called during battle
	{
		return false;
	}
});
