::Hardened.HooksMod.hook("scripts/retinue/followers/minstrel_follower", function(q) {
	// Public
	q.m.HD_SettlementsToVisit <- 15;

	q.create = @(__original) function ()
	{
		__original();
		this.m.Cost = 500;		// Vanilla: 2000
		this.m.Effects[0] = "Earn 15% more Renown";
		this.m.Effects.remove(1);	// Remove tooltip about tavern rumors
	}

	q.onUpdate = @(__original) function()
	{
		__original();
		::World.Assets.m.IsNonFlavorRumorsOnly = false;		// The minstrel no longer makes useful tavern rumors more likely
	}

	// Overwrite, because we make the condition more moddable and easier to fulfill. We also tweak the requirements text
	q.onEvaluate = @() function()
	{
		local settlements = ::World.EntityManager.getSettlements();

		local settlementsToVisit = ::Math.min(this.m.HD_SettlementsToVisit, settlements.len());

		local settlementsVisited = 0;
		foreach (s in settlements)
		{
			if (s.isVisited()) settlementsVisited = ++settlementsVisited;
		}

		this.m.Requirements[0].Text = "Visit " + settlementsVisited + "/" + settlementsToVisit + " Settlements";

		if (settlementsVisited >= settlementsToVisit)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}
});
