::Hardened.HooksMod.hook("scripts/events/events/dlc2/location/ancient_temple_enter_event", function(q) {
	q.create = @(__original) function()
	{
		__original();

		foreach (screen in this.m.Screens)
		{
			{	// Feat: Offering the dude to join the company now actually makes him join the company
				if (screen.ID == "K")
				{
					screen.Text = screen.Text.slice(0, screen.Text.find("Get it?%SPEECH_OFF%"));
					screen.Text += "Get it?%SPEECH_OFF%You take a closer look at the guy and find that he wasn\'t kidding, its half made of wood! Still, whatever madness drives him makes you think he might just be useful.%SPEECH_ON%Alright then, %idiot%. Welcome to the %companyname%.%SPEECH_OFF%";

					local oldStart = screen.start;
					screen.start = function( _event ) {
						oldStart(_event);
						this.Characters.push(_event.m.Dude.getImagePath());
					}

					screen.Options[0].Text = "Still a successful go, all things considered.";
					screen.Options[0].getResult = function( _event ) {
						::World.getPlayerRoster().add(_event.m.Dude);
						::World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}
				}
				else if (screen.ID == "J")
				{
					local oldStart = screen.start;
					screen.start = function( _event ) {
						oldStart(_event);
						_event.m.Dude.getBackground().m.RawDescription = "You found %name% in an Ancient Temple, challenging you with riddles. The time alone in the dark must have driven his mind mad, the half of it that isn't made of wood, of course. Still, you chose to take that fool with you.";
						_event.m.Dude.getBackground().buildDescription(true);
						_event.m.Dude.setTitle("the Riddler");
						_event.m.Dude.getSkills().add(::new("scripts/skills/injury_permanent/brain_damage_injury"));
						_event.m.Dude.updateInjuryVisuals();
						local trait = ::new("scripts/skills/traits/mad_trait");
						_event.m.Dude.getSkills().add(trait);
					}

					// We prevent vanilla from clearing the temporary roster, as we keep using it
					screen.Options[0].getResult = function( _event ) {
						return "K";
					}
				}
			}

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
