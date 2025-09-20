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

				if (!("start" in screen)) screen.start <- function() {};

				// Feat: We display the names of all participants to the player so that he has a chance to spot any mistakes made
				local oldStart = screen.start;
				screen.start = function ()
				{
					oldStart();
					local participantId = 50;
					foreach (participant in this.Contract.getBros())
					{
						this.List.push({
							id = participantId,
							icon = "ui/icons/asset_brothers.png",
							text = participant.getName(),
						});
						participantId++;
					}
				}
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
