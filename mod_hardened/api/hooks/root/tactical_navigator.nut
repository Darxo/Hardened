local oldTeleport = ::TacticalNavigator.teleport;
::TacticalNavigator.teleport <- function(_user, _targetTile, _onDone, _table, _bool, _float = 1.0)
{
	if (::Hardened.TileReservation.isReserved(_targetTile.ID))
	{
		::logInfo("Hardened: Prevented teleport onto reserved Tile");
		return;	// We no longer allow two entities to teleport onto the same tile
	}

	local oldCallback = _onDone;
	_onDone = function( _entity, _tag )
	{
		::Hardened.TileReservation.endReserveation(_targetTile.ID);		// We remove the Reservation for the destination of this teleport call
		if (oldCallback != null)	// Some teleports pass null instead of the optional callback function
		{
			oldCallback(_entity, _tag);
		}
	}

	::Hardened.TileReservation.reserveTile(_targetTile.ID);		// We reserve the destination of this teleport call
	oldTeleport(_user, _targetTile, _onDone, _table, _bool, _float);
}
