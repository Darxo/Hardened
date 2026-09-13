::Hardened.HooksMod.hook("scripts/mapgen/templates/tactical/locations/tactical_human_camp", function(q) {
	q.fill = @(__original) { function fill( _rect, _properties, _pass = 1 )
	{
		local oldShiftX = _properties.ShiftX;
		if (!::Tactical.State.getStrategicProperties().HD_IsAttackingLocation)
		{
 			_properties.ShiftX *= -1;
		}

		__original(_rect, _properties, _pass);

		this.HD_guaranteeWallOpenings(_rect, _properties);

 		_properties.ShiftX = oldShiftX;
	}}.fill;

// New Functions
	// Remove one wall segment in the center of every of the 6 hexagon sides to guarantee openings
	q.HD_guaranteeWallOpenings <- function( _rect, _properties )
	{
		local centerTile = ::Tactical.getTileSquare(_rect.W / 2 + _properties.ShiftX, _rect.H / 2 + _properties.ShiftY);
		local radius = ::Const.Tactical.Settings.CampRadius + _properties.AdditionalRadius;
		for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
			{
				local tile = ::Tactical.getTileSquare(x, y);
				local distance = centerTile.getDistanceTo(tile);
				if (distance != radius) continue;

				if (x == (centerTile.SquareCoords.X - ::Math.round(radius / 2)))
				{
					tile.removeObject();
				}
				else if (x == (centerTile.SquareCoords.X + ::Math.round(radius / 2)))
				{
					tile.removeObject();
				}
				else if (y == centerTile.SquareCoords.Y)
				{
					tile.removeObject();
				}
			}
		}
	}
});
