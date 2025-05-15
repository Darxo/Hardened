::Hardened.HooksMod.hook("scripts/retinue/followers/recruiter_follower", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[0] = "Makes you pay 50% less for tryouts";
	}

	q.onUpdate = @(__original) function()
	{
		// We revert any changes to hiring cost
		local oldHiringCostMult = ::World.Assets.m.HiringCostMult;
		__original();
		::World.Assets.m.HiringCostMult = oldHiringCostMult;
	}
});
