::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_vigorous_assault", function(q) {
	// Overwrite because this effect is no longer lost when swapping weapons
	q.onPayForItemAction = @() function( _skill, _items )
	{
	}
});
