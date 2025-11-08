::Hardened.HooksMod.hook("scripts/scenarios/world/trader_scenario", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = ::MSU.String.replace(this.m.Description, "Start with no renown, and gain renown at only 66% the normal rate.", "Gain 34% less Renown.");
	}
});
