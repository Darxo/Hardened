::Hardened.HooksMod.hook("scripts/skills/perks/perk_battle_forged", function(q) {
	q.getReachIgnore = @() function()
	{
		return 0;	// Do nothing: Battle Forged no longer grants reach ignore
	}
});
