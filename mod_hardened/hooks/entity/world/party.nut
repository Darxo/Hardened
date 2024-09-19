::Hardened.HooksMod.hook("scripts/entity/world/party", function(q) {
	// Private
	q.m.LastTroopSize <- 0;		// temporary variable to prevent

	q.onAfterInit = @(__original) function()
	{
		__original();

		// Add new sprite for optionally displaying the mini boss skull on the world entities bust
		local socketMinibossSprite = this.addSprite("socket_miniboss");
		socketMinibossSprite.setBrush("bust_miniboss");		// tactical entities already have this
		// socketMinibossSprite.Scale = 0.45;					// This sprite was initially made for tactical entities, not the smaller world ones. 0.45 is ideal for the smaller goblin base but a bit tight for the bigger orc ones
		// socketMinibossSprite.setOffset(::createVec(4, 6));	// Move the sprite so it fits perfectly on the common sockets
		socketMinibossSprite.Color = ::createColor("ffaa00ff");	// Move the sprite so it fits perfectly on the common sockets
		socketMinibossSprite.Visible = false;	// Move the sprite so it fits perfectly on the common sockets
	}

	q.onUpdate = @(__original) function()
	{
		__original();

		if (!this.m.IsPlayer && this.m.LastTroopSize != this.getTroops().len())		// My troop size has changed. So a champion might have been removed from it
		{
			this.getSprite("socket_miniboss").Visible = false;

			if (this.getSprite("base").Visible)	// Some world parties, like Caravans, don't display a socket. It would look weird to display the miniboss symbol for them
			{
				// Check whether this party has any miniboss in it
				foreach (entity in this.getTroops())
				{
					if (entity.Variant != 0)	// Indicator for it being a champion/miniboss
					{
						local sprite = this.getSprite("socket_miniboss");
						sprite.Visible = true;

						// Somehow its not enough to do these during onInit. But I don't know where else to do it
						// It seems like they get overwritte/reset once after onInit. Something is setting the scale of all sprites on this party to 0.5
						sprite.setOffset(::createVec(4, 6));
						sprite.Scale = 0.45;

						break;
					}
				}
			}
		}
	}
});
