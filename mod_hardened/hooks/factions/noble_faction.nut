::Hardened.HooksMod.hook("scripts/factions/noble_faction", function(q) {
// Hardened Functions
	q.HD_getMaxConcurrentContracts = @() function()
	{
		// Feat: raise maximum amount of contracts for noble factions to 3 (up from 1)
		return 3;
	}
});
