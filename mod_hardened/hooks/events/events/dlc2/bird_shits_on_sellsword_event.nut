::Hardened.HooksMod.hook("scripts/events/events/dlc2/bird_shits_on_sellsword_event", function(q) {
	q.m.AmmoModifierForBird <- 5;	// The Archer option of this event now costs this much ammo

	q.create = @(__original) function()
	{
		__original();

		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "Archer")
			{
				local oldStart = screen.start;
				screen.start = function( _event )
				{
					::World.Assets.addAmmo(-1 * _event.m.AmmoModifierForBird);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "You lose " + ::MSU.Text.colorizeValue(-1 * _event.m.AmmoModifierForBird, {AddSign = true}) + " Ammunition",
					});

					oldStart(_event);
				}
				break;
			}
		}
	}

	q.onUpdateScore = @(__original) function()
	{
		__original();
		if (::World.Assets.getAmmo() < this.m.AmmoModifierForBird)
		{
			this.m.Archer = null;
		}
	}
});


