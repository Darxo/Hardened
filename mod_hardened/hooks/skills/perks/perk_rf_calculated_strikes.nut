::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_calculated_strikes", function(q) {
// Reforged Functions
	// Fix(Reforged): Overwrite because we exclude the now redundant condition about isTurnDone, which allows this perk to work against stunned enemies and similar
	q.isEnabledFor = @() function( _targetEntity )
	{
		return !_targetEntity.isTurnStarted();
	}
});
