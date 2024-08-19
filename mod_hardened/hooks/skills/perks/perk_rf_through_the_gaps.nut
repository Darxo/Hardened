::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_through_the_gaps", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "";
		this.m.IsSpent = false;	// this is now active all the time
		this.m.DirectDamageModifier = -0.1;
	}

	q.isHidden = @(__original) function()
	{
		return true;	// This is now always hidden because it is always active
	}

	q.onAnySkillExecuted = @(__original) function(_skill, _targetTile, _targetEntity, _forFree)
	{
		__original(_skill, _targetTile, _targetEntity, _forFree);
		this.m.IsSpent = false;		// We reset this back to false so it stays active all the time
		return;
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.IsSpent = false;		// We reset this back to false so it stays active all the time
	}
});
