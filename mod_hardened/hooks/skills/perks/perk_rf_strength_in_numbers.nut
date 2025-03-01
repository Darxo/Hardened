::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_strength_in_numbers", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this perk grants combat stats and resolve depending on adjacent allies
	}
});
