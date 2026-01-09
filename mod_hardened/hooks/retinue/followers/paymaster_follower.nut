::Hardened.HooksMod.hook("scripts/retinue/followers/paymaster_follower", function(q) {
	// Public
	q.m.HD_RequiredDailyExpenses <- 500;	// This much daily expenses (usually wages) are required to unlock this follower
	q.m.HD_WageMult <- 0.75;	// This is the wage discount for brothers, which this follower grants

	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[0] = (100 - this.m.HD_WageMult * 100) + "% less Daily Wage";
	}

	// Overwrite, because Vanilla overwrites existing values instead of adding to them
	q.onUpdate = @() function()
	{
		::World.Assets.m.DailyWageMult *= this.m.HD_WageMult;	// Vanilla: 0.85
	}

	// Overwrite, because we introduce a completely different custom condition
	q.onEvaluate = @() function()
	{
		local dailyExpenses = ::World.Assets.getDailyMoneyCost();
		this.m.Requirements[0].IsSatisfied = dailyExpenses >= this.m.HD_RequiredDailyExpenses;
		this.m.Requirements[0].Text = "Have " + dailyExpenses + "/" + this.m.HD_RequiredDailyExpenses + " Daily Expenses";
	}
});
