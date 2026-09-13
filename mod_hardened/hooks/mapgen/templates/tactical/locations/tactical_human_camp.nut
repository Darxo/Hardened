::Hardened.HooksMod.hook("scripts/mapgen/templates/tactical/locations/tactical_human_camp", function(q) {
	q.fill = @(__original) { function fill( _rect, _properties, _pass = 1 )
	{
		local oldShiftX = _properties.ShiftX;
		if (!::Tactical.State.getStrategicProperties().HD_IsAttackingLocation)
		{
 			_properties.ShiftX *= -1;
		}

		__original(_rect, _properties, _pass);

 		_properties.ShiftX = oldShiftX;
	}}.fill;
});
