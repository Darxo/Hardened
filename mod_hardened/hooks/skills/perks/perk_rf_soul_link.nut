::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_soul_link", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because our mini-icon is applied depending on whether we have an adjacent allies
		__original(_properties);
	}
});
