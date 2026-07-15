local oldAddTroop = ::Const.World.Common.addTroop;
::Const.World.Common.addTroop = function( _party, _troop, _updateStrength = true, _minibossify = 0 )
{
	// Feat: Unique locations no longer randomly make units champions, unless their champion chance is 100 or above
	if (_party.isLocation() && _party.isLocationType(::Const.World.LocationType.Unique) && _troop.Type.Variant < 100)
	{
		_minibossify = -999;
	}

	return oldAddTroop(_party, _troop, _updateStrength, _minibossify);
}
