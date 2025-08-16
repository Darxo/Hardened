::Hardened.HooksMod.hook("scripts/events/events/crisis/civilwar_town_conquered_event", function(q) {
	// Overwrite, because we remove the condition of needing to be on a road, to mitigate a queuing issue with news
	q.onUpdateScore = @(__original) function()
	{
		if (::World.Statistics.hasNews("crisis_civilwar_town_conquered"))
		{
			this.m.Score = 2000;
		}
	}
});
