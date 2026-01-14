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
				if (nearbyEntity.isLocation() && !nearbyEntity.isDiscovered() && nearbyEntity.m.VisibilityMult > 0.0)
				{
					// This does not flip this.isHiddenToPlayer() of the location so the cartographer will not give money for newly discovered locations
					nearbyEntity.setDiscovered(true);
					nearbyEntity.onDiscovered();

					// We want the cartographer to pay for previously undiscovered locations, and those to count for ambitions
					// The vanilla code inside location::onDiscovered does not trigger, because isHiddenToPlayer is not yet flipped, so we need to manually do the same logic here
					if (nearbyEntity.isHiddenToPlayer() && nearbyEntity.getTypeID() != "location.battlefield")
					{
						::World.Statistics.getFlags().increment("LocationsDiscovered");

						if (::World.Retinue.hasFollower("follower.cartographer"))
						{
							::World.Retinue.getFollower("follower.cartographer").onLocationDiscovered(nearbyEntity);
						}

						::World.Ambitions.onLocationDiscovered(nearbyEntity);
					}
				}
			}

			return 0;
		}
	}
});
