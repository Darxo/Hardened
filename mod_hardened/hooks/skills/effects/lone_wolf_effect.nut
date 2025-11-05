::Hardened.HooksMod.hook("scripts/skills/effects/lone_wolf_effect", function(q) {
	q.m.RequiredIsolationDistance <- 2;

	q.onUpdate = @(__original) function( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because our bonus is applied depending on how many adjacent allies there are
		__original(_properties);
	}

// Reforged Functions
	// Overwrite of Reforged function because we change the condition for the long wolf effect
	q.isInValidPosition = @() function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;

		local myTile = actor.getTile();
		foreach (nearbyAlly in ::Tactical.Entities.getInstancesOfFaction(actor.getFaction()))
		{
			if (nearbyAlly.getID() == actor.getID()) continue;
			if (!nearbyAlly.isPlacedOnMap()) continue;

			if (nearbyAlly.getTile().getDistanceTo(myTile) <= this.m.RequiredIsolationDistance) return false;
		}

		return true;
	}
});
