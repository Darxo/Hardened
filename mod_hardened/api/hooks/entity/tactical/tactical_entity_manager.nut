::Hardened.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	q.spawn = @(__original) function( _properties )
	{
		::Hardened.TileReservation.onCombatStarted();
		__original(_properties);
	}

	q.addCorpse = @(__original) function( _tile )
	{
		__original(_tile);
		if (_tile.Properties.has("Corpse"))
		{
			_tile.Properties.get("Corpse").RoundAdded <- ::Tactical.TurnSequenceBar.getCurrentRound();
		}
	}
});
