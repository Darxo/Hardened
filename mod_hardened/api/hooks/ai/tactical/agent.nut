::Hardened.HooksMod.hook("scripts/ai/tactical/agent", function(q) {
	q.onRoundStarted = @(__original) function()
	{
		__original();
		this.m.IsTurnStarted = false;	// We now set this variable to false here, instead of having vanilla set it to false during onTurnEnd
	}

	q.onTurnEnd = @(__original) function()
	{
		__original();
		this.m.IsTurnStarted = true;
		// Vanilla sets this to false here, which is misleading and annyoing for modder and effect implementations
		// Someone who ended their turn still has had their turn started this round
	}
});
