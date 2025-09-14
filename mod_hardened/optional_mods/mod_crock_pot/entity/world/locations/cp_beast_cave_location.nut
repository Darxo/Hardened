::Hardened.HooksMod.hook("scripts/entity/world/locations/cp_beast_cave_location", function(q) {
	// Overwrite, because we disable the CrockPot artificial day scaling for roaming parties,
	// 	because that is already covered by ::Hardened.Global.getWorldDifficultyMult() globally
	q.getDayScalingMult = @() function()
	{
		return 1.0;
	}
});
