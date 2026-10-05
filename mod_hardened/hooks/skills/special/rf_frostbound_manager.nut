::Hardened.HooksMod.hook("scripts/skills/special/rf_frostbound_manager", function(q) {
	// Overwrite, because we no longer outright remove this manager when an immunity is detected
	q.onAdded = @() function() {}

	q.onTurnStart = @(__original) function()
	{
		// We only prevent the effects, so that we can handle temporary immunities
		if (this.getContainer().getActor().getCurrentProperties().HD_ImmuneToChilled) return;

		__original();
	}

	q.onTurnEnd = @(__original) function()
	{
		// We only prevent the effects, so that we can handle temporary immunities
		if (this.getContainer().getActor().getCurrentProperties().HD_ImmuneToChilled) return;

		__original();
	}
});
