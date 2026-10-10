::Hardened.HooksMod.hook("scripts/factions/noble_faction", function(q) {
// Hardened Functions
	q.HD_getMaxConcurrentContracts = @() function()
	{
		// Feat: raise maximum amount of contracts for noble factions to 3 (up from 1)
		return 3;
	}

	q.HD_getContractDelay = @() function()
	{
		if (::World.getTime().Days <= 1) return null;

		// Feat: change cooldown for new noble contracts to 1 day (down from 3)
		return 1 * ::World.getTime().SecondsPerDay;
	}
});
