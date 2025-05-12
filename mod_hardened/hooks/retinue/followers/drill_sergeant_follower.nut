::Hardened.HooksMod.hook("scripts/retinue/followers/drill_sergeant_follower", function(q) {
	q.create = @(__original) function ()
	{
		__original();
		this.m.Requirements = [		// Just like in Vanilla. In Reforged this is empty
			{
				IsSatisfied = false,
				Text = "Retired a man with a permanent injury that isn\'t indebted",
			},
		];
	}

	// Overwrite, because Reforged has deleted this condition
	q.onEvaluate = @() function()
	{
		if (::World.Statistics.getFlags().getAsInt("BrosWithPermanentInjuryDismissed") > 0)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}
});
