::Hardened.HooksMod.hook("scripts/skills/effects/rf_onslaught_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.TurnsLeft = 3;	// In Reforged this is 1. We set this to any higher value, as we don't want Reforgeds turn-based duration to interfer with our round-based one

		this.m.HD_LastsForRounds = 2;	// We now use a round-based duration
	}

	q.onRefresh = @(__original) function()
	{
		__original();
		this.m.HD_LastsForRounds = 2;
	}
});
