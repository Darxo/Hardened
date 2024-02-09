::Hardened.HooksMod.hook("scripts/skills/effects/rf_encumbrance_effect", function(q) {
	q.getMovementFatigueCostModifier = @() function( _encumbranceLevel )
	{
		return _encumbranceLevel;
	}

	q.getFatigueOnTurnStart = @() function( _encumbranceLevel )
	{
		return 0;
	}
});
