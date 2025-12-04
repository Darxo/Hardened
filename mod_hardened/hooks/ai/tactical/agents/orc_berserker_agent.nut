::Hardened.HooksMod.hook("scripts/ai/tactical/agents/orc_berserker_agent", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Properties.EngageTargetMultipleOpponentsMult = 0.5;
	}

	// Overwrite, because we don't want to Vanilla to set EngageTargetMultipleOpponentsMult to a negative value. That is unforeseen consequences during engage_melee
	q.onUpdate = @(__original) function() {}
});
