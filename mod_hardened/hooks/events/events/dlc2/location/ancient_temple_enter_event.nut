::Hardened.HooksMod.hook("scripts/events/events/dlc2/location/ancient_temple_enter_event", function(q) {
	q.create = @(__original) function()
	{
		__original();

		foreach (screen in this.m.Screens)
		{
			{	// Feat: The Ancient Temple now also grants you a guaranteed itemized Perk Point
				if (screen.ID == "F" || screen.ID == "H" || screen.ID == "I" || screen.ID == "K" || screen.ID == "L")
				{
					local oldStart = screen.start;
					screen.start = function( _event ) {
						oldStart(_event);
						::World.Assets.getStash().makeEmptySlots(1);
						local item = ::new("scripts/items/special/trade_jug_02_item");
						::World.Assets.getStash().add(item);
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You gain " + ::Const.Strings.getArticle(item.getName()) + item.getName(),
						});
					}

					local newText = "\n\nOn your way out, you suddenly notice a small jug set apart from the rest. Its surface is worked with neat figures and patterns, suggesting it might fetch a good price, so you take it.";
					if (screen.ID == "F")
					{
						screen.Text = ::MSU.String.replace(screen.Text, "\n\n Outside, you find the", newText + "\n\nOutside, you find the");
					}
					else if (screen.ID == "H")
					{
						screen.Text = ::MSU.String.replace(screen.Text, "You take the vials", newText + "\n\nYou take the vials and the jug");
					}
					else
					{
						screen.Text += newText;
					}
				}
			}
		}
	}
});
