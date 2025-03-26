::Hardened.HooksMod.hook("scripts/events/events/dlc2/location/ancient_watchtower_event", function(q) {
	q.m.RevealRadius <- 3000.0;		// In vanilla this is 1900.0

	q.create = @(__original) function()
	{
		__original();

		// We overwrite the vanilla getResult
		this.m.Screens[0].Options[0].getResult = function( _event )
		{
			::World.uncoverFogOfWar(::World.State.getPlayer().getPos(), _event.m.RevealRadius);

			// Reveal all nearby locations to the player
			local allNearbyEntitities = ::World.getAllEntitiesAtPos(::World.State.getPlayer().getPos(), _event.m.RevealRadius);
			foreach (nearbyEntity in allNearbyEntitities)
			{
				if (nearbyEntity.isLocation() && nearbyEntity.m.VisibilityMult > 0.0)
				{
					nearbyEntity.setDiscovered(true);
					nearbyEntity.onDiscovered();
				}
			}

			return 0;
		}
	}
});
