::Hardened.HooksMod.hook("scripts/skills/effects/rf_arrow_to_the_knee_debuff_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.HD_LastsForTurns = this.m.StartingTurnsLeft;		// We now use the Hardened API for turn duration
	}

	q.onAdded = @(__original) function()
	{
		__original();
		this.onRefresh();
	}

	q.onRefresh = @(__original) function()
	{
		__original();
		this.m.HD_LastsForTurns = ::Math.max(1, this.m.StartingTurnsLeft + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	// We overwrite this because we implement the effect duration via HD_LastsForTurns
	q.onTurnEnd = @() function() {}
});
