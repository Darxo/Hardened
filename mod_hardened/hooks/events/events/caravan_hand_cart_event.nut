::Hardened.HooksMod.hook("scripts/events/events/caravan_hand_cart_event", function(q) {
	// Overwrite, because we change how the event triggers:
	// - This event can now also trigger if you upgraded your cart already
	q.onUpdateScore = @() function()
	{
		local brothers = ::World.getPlayerRoster().getAll();
		if (brothers.len() < 3) return;

		local candidates = [];
		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.caravan_hand")
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() == 0) return;

		this.m.CaravanHand = ::MSU.Array.rand(candidates);
		this.m.Score = candidates.len() * 5;
	}
});
