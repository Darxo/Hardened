::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.initNextRound = @(__original) function()	// This is called during battle
	{
		::Hardened.TileReservation.onNewRound();
		__original();
	}
});
