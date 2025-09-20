::Hardened.HooksMod.hook("scripts/contracts/contracts/arena_contract", function(q) {
	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "Start")
			{
				// Feat: We allow the player to cancel the arena dialog, if they wanna adjust their participants
				screen.Options.push(
				{
					Text = "I\'ll have to think it over.",
					function getResult()
					{
						return 0;
					},
				});
			}
		}
	}

	// Feat: reequip previous accessory after the arena contract ended
	q.onClear = @(__original) function()
	{
		if (this.isActive())
		{
			foreach (bro in ::World.getPlayerRoster().getAll())
			{
				local item = bro.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
				if (item != null && item.getID() == "accessory.arena_collar")
				{
					bro.getItems().unequip(item);	// We need to make room for the old accessory, so we remove the arena collar a bit early (before vanilla does it)
					item.HD_reequipPreviousItem();
				}
			}
		}

		__original();
	}
});
