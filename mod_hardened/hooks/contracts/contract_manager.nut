::Hardened.HooksMod.hook("scripts/contracts/contract_manager", function(q) {
// Hardened Functions
	q.HD_getMaxContractTier = @() function()
	{
		local level = 1;

		if (::World.Ambitions.getCompleted() > 0) ++level;
		if (::World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone()) ++level;

		return level;
	}
});
