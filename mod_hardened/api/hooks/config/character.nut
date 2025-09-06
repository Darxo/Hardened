// New Values
::Const.CharacterProperties.HitpointRecoveryMult <- 1.0;	// Any flat hitpoint recovery is scaled by this value. This does not affect percentage recovery

// If true, then this actors skill container gets updated, when something is spawned onto the battlefield or moves
::Const.CharacterProperties.UpdateWhenTileOccupationChanges <- false;

local oldSetValue = ::Const.CharacterProperties.setValues;
::Const.CharacterProperties.setValues = function( _table )
{
	oldSetValue(_table);

	// We now also support the new Reforged value "Reach" in this function
	if (_table.rawin("Reach"))
	{
		this.Reach = _table.Reach;
	}
}
