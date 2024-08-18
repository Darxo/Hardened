::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.isRemovingEntity = @() function()	// This is called during battle
	{
		// If the delay is too long (like 2.0 in vanilla), then a players unleashed dog might skip a turn because someone dead during that time
		// If this function always returns false, then the game might freeze, when a goblin wolf rider dies while fleeing and spawning a wolf. Somehow that wolf will then not act anymore
		return this.m.LastRemoveTime + 0.25 >= ::Time.getRealTimeF();
	}
});
