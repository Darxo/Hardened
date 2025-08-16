::Hardened.HooksMod.hook("scripts/events/events/crisis/undead_town_destroyed_event", function(q) {
	// Overwrite, because we remove the condition of needing to be on a road, to mitigate a queuing issue with news
	q.onUpdateScore = @(__original) function()
	{
		if (::World.Statistics.hasNews("crisis_undead_town_destroyed"))
		{
			this.m.Score = 2000;
		}
	}
});
