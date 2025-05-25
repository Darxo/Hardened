::Hardened.HooksMod.hook("scripts/retinue/followers/surgeon_follower", function(q) {
	// Public
	q.m.HD_RequiredTreatedInjuries <- 5;

	// Overwrite, because we change the condition the requirement text, and make it more moddable
	q.onEvaluate = @() function()
	{
		local injuriesTreated = 0;
		injuriesTreated += ::World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple");	// This flag is incremented in Vanilla
		injuriesTreated += ::World.Statistics.getFlags().getAsInt("InjuriesTreatedWithBandage");	// This flag is incremented in Hardened

		injuriesTreated = ::Math.min(this.m.HD_RequiredTreatedInjuries, injuriesTreated);

		this.m.Requirements[0].Text = "Treated " + injuriesTreated + "/" + this.m.HD_RequiredTreatedInjuries + " Injuries with Bandages or at a Temple";
		if (injuriesTreated >= this.m.HD_RequiredTreatedInjuries)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}
});
