::Hardened.HooksMod.hook("scripts/events/events/dlc6/crisis/holywar_occupied_south_event", function(q) {
	// Overwrite, because we remove the condition of needing to be on a road, to mitigate a queuing issue with news
	q.onUpdateScore = @(__original) function()
	{
		if (::World.Statistics.hasNews("crisis_holywar_holysite_south"))
		{
			this.m.Score = 2000;
		}
	}
});
