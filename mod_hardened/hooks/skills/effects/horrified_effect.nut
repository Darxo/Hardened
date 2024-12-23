::Hardened.HooksMod.hook("scripts/skills/effects/horrified_effect", function(q) {
	// Revert any changes to ActionPoints by horrified effect
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
});
