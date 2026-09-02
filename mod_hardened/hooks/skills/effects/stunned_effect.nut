::Hardened.HooksMod.hook("scripts/skills/effects/stunned_effect", function(q) {
	// Vanilla Fix: Ensure that self-removal due to present immunity is done using removeSelf() instead of adjusting the value directly
	q.m.HD_PreventedByProperties = ["IsImmuneToStun"];

	// Revert any changes to ActionPoints by stun effect
	q.onUpdate = @(__original) function( _properties )
	{
		local actor = this.getContainer().getActor();
		local oldActionPoints = actor.getActionPoints();

		__original(_properties);

		actor.setActionPoints(oldActionPoints);
	}

	// Set ActionPoints to 0 at the start of the turn, just like with the vanilla sleeping effect
	q.onTurnStart = @(__original) function()
	{
		__original();
		this.getContainer().getActor().setActionPoints(0);
	}

	// Set ActionPoints to 0 when resuming the turn, incase a character got stunned during the second half of their turn
	q.onResumeTurn = @(__original) function()
	{
		__original();
		this.getContainer().getActor().setActionPoints(0);
	}

	q.setTurns = @(__original) { function setTurns( _turns )
	{
		// Vanilla Fix: Vanilla only does a basic null check for the state of getContainer() but the returned values is a WeakTableRef and requires an additional check
		if (::MSU.isNull(this.getContainer())) return;

		__original(_turns);
	}}.setTurns;
});
