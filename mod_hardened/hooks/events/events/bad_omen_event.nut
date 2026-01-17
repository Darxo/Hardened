::Hardened.HooksMod.hook("scripts/events/events/bad_omen_event", function(q) {
	q.onUpdateScore = @(__original) function()
	{
		__original();

		this.m.Cooldown = 21.0 * ::World.getTime().SecondsPerDay;	// Vanilla: 14 Days
	}
});
