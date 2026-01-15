::Hardened.HooksMod.hook("scripts/skills/special/mood_check", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// We show the accurate mood, instead of a percentage representation of it
		local actor = this.getContainer().getActor();
		this.m.Name = ::Const.MoodStateName[actor.getMoodState()] + " (" + actor.getMood() + "/7.0)";
	}
});
