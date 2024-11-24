::Hardened.TileReservation <- {
	TilesUsed = [],	// Array of tile IDs, that are currently empty but about to be filled with an entity

	// Must be called once at the start of every combat
	function onCombatStarted()
	{
		this.TilesUsed = [];
	}

	// Clean any reservations that are expired
	function onNewRound()
	{
		for (local i = this.TilesUsed.len() - 1; i >= 0; --i)
		{
			if (tileReservation[i].Round < ::Time.getRound())
			{
				this.TilesUsed.remove(i);
			}
		}
	}

	// Return true if the tile with the ID _tileID is currently the reserved because it is the target of a movement
	function isReserved( _tileID )
	{
		return this.TilesUsed.find(_tileID) != null;
	}

	function reserveTile( _tileID )
	{
		this.TilesUsed.push({
			ID = _tileID,
			RoundReserved = ::Time.getRound(),
		});
	}

	// Remove the reservation for _tileID
	// @return the removed object if successful, null otherwise
	function endReserveation( _tileID )
	{
		foreach (index, tileReservation in this.TilesUsed)
		{
			if (tileReservation.ID == _tileID)
			{
				return this.TilesUsed.remove(index);
			}
		}
		return null;
	}
}
