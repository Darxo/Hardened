::Hardened.HooksMod.hook("scripts/events/events/dlc2/location/ancient_watchtower_event", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// We overwrite the vanilla getResult
		this.m.Screens[0].Options[0].getResult = function( _event )
		{
			local revealRadius = 3000.0;	// In vanilla this is 1900.0
			::World.uncoverFogOfWar(::World.State.getPlayer().getPos(), revealRadius);

			// Reveal all nearby locations to the player
			local allNearbyEntitities = ::World.getAllEntitiesAtPos(::World.State.getPlayer().getPos(), revealRadius);
			foreach (nearbyEntity in allNearbyEntitities)
			{
				if (nearbyEntity.isLocation() && nearbyEntity.m.VisibilityMult != 0.0)
				{
					nearbyEntity.setDiscovered(true);
				}
			}

			return 0;
		}
	}
});
