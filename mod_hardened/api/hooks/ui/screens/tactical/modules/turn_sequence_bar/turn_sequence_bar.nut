::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	// Private
	q.m.HD_EndTurnProtectionLast <- 0;

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

	q.onNextTurnButtonPressed = @() function()
	{
		this.HD_endPlayerTurn();
	}

// New Functions
	// New action, that is called either from the end-turn keybind or from pressing the end-turn button
	q.HD_endPlayerTurn <- function()
	{
		if (this.HD_canEndTurn())
		{
			this.initNextTurn();
		}
	}

	q.HD_canEndTurn <- function()
	{
		local activeEntity = this.getActiveEntity();
		if (activeEntity == null) return;
		if (!this.getActiveEntity().isPlayerControlled()) return;

		// Feat: Allow end-turn protection to prevent the turn-end action from taking effect
		return (::Time.getRealTime() > (this.m.HD_EndTurnProtectionLast + this.HD_getProtectTurnEndDuration()));
	}

	q.HD_protectTurnEnd <- function()
	{
		this.m.HD_EndTurnProtectionLast = ::Time.getRealTime();
	}

	q.HD_getProtectTurnEndDuration <- function()
	{
		return 1000.0 * ::Hardened.Mod.ModSettings.getSetting("EndTurnProtectionDuration").getValue();
	}
});
