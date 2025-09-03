::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.initNextRound = @(__original) function()	// This is called during battle
	{
		::Hardened.TileReservation.onNewRound();
		__original();
	}

	q.initNextTurn = @(__original) function( _force = false )
	{
		if (this.m.CurrentEntities.len() == 0) return __original(_force);

		local activeEntity = this.m.CurrentEntities[0];
		local oldTurnPosition = this.m.TurnPosition;

		__original(_force);

		// The original function has a lot of early return. One way we can be sure that it passed all those returns is to check whether "++this.m.TurnPosition;" has been executed
		if (this.m.TurnPosition == oldTurnPosition + 1 && activeEntity.isAlive())
		{
			// Vanilla Fix: We update an actor one final time after he ended his turn and was removed from the active position
			// That will make sure that effects, which provide their passive effect only/not during this actors turn, will update immediately
			activeEntity.getSkills().update();
		}
	}

	q.initNextTurnBecauseOfWait = @(__original) function()
	{
		if (this.m.CurrentEntities.len() == 0) return __original();

		local activeEntity = this.m.CurrentEntities[0];
		local oldTurnPosition = this.m.TurnPosition;

		__original();

		// The original function has a lot of early return. One way we can be sure that it passed all those returns is to check whether "++this.m.TurnPosition;" has been executed
		if (this.m.TurnPosition == oldTurnPosition + 1 && activeEntity.isAlive())
		{
			// Vanilla Fix: We update an actor one final time after he ended his turn and was removed from the active position
			// That will make sure that effects, which provide their passive effect only/not during this actors turn, will update immediately
			activeEntity.getSkills().update();
		}
	}
});
