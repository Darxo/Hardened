::Hardened.HooksMod.hook("scripts/states/tactical_state", function(q) {
	q.onBattleEnded = @(__original) function()
	{
		if (!this.m.IsExitingToMenu)	// In vanilla this function ends early so we don't apply our switcheroo
		{
			::Const.Faction.Player = 0;		// Swicheroo: set player faction briefly to 0 to prevent vanilla from revealing the map for the player
		}

		__original();
	}
});
