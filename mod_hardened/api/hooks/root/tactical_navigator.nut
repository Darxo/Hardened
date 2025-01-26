local oldTeleport = ::TacticalNavigator.teleport;
::TacticalNavigator.teleport <- function(_user, _targetTile, _onDone, _table, _bool, _float = 1.0)
{
	if (::Hardened.TileReservation.isReserved(_targetTile.ID))
	{
		::logInfo("Hardened: Prevented teleport onto reserved Tile");
		return;	// We no longer allow two entities to teleport onto the same tile
	}

	if (_table == null) _table = {};	// In Vanilla its allowed to pass null here
	_table.RootSkillCounter <- ::Hardened.Temp.RootSkillCounter;	// We preserve the root skill counter

	local oldCallback = _onDone;
	_onDone = function( _entity, _tag )
	{
		::Hardened.TileReservation.endReserveation(_targetTile.ID);		// We remove the Reservation for the destination of this teleport call
		if (oldCallback != null)	// Some teleports pass null instead of the optional callback function
		{
			::Hardened.Temp.RootSkillCounter = _tag.RootSkillCounter;
			oldCallback(_entity, _tag);
			::Hardened.Temp.RootSkillCounter = null;
		}
	}

	::Hardened.TileReservation.reserveTile(_targetTile.ID);		// We reserve the destination of this teleport call
	oldTeleport(_user, _targetTile, _onDone, _table, _bool, _float);
}
