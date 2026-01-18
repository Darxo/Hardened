::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_calculated_strikes", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.InitiativeMult = 0.85;	// Reforged: 0.8
	}

// Reforged Functions
	// Fix(Reforged): Overwrite because we exclude the now redundant condition about isTurnDone, which allows this perk to work against stunned enemies and similar
	q.isEnabledFor = @() function( _targetEntity )
	{
		return !_targetEntity.isTurnStarted();
	}
});
