::Hardened.HooksMod.hook("scripts/skills/perks/perk_battle_flow", function(q) {
	// Overwrite, because we no longer reset this effect on turn start
	q.onTurnStart = @() function() {}

	// This effect now resets on Round start so its effect works exactly as advertised on the perk description
	q.onNewRound = @(__original) function()
	{
		__original();

		this.m.IsSpent = false;
	}
});
