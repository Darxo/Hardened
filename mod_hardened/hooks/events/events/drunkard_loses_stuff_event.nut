::Hardened.HooksMod.hook("scripts/events/events/drunkard_loses_stuff_event", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Cooldown = 21.0 * ::World.getTime().SecondsPerDay;	// Vanilla: 14 Days

		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "A")
			{
				screen.Options.push({
					Text = "You will not rest until you found that item, even if it takes the whole day!",
					function getResult( _event )
					{
						return "CP_RecoverItem";
					}
				});
				break;
			}
		}
		this.m.Screens.push({
			ID = "CP_RecoverItem",
			Text = "[img]gfx/ui/events/event_05.png[/img]" +
			"You glare at the drunkard and point to the entrance." +
			"%SPEECH_ON%You lost it, you find it. I don\'t care how long it takes.%SPEECH_OFF% " +
			"The man\'s expression slumps into something between despair and shame. You remind him how valuable the item was and that it is his blunder that put it at risk. " +
			"He stumbles out into the daylight, one hand shielding his eyes, the other clutching his head as if to hold it together.\n\n" +
			"Hours pass. Then more. The sun begins to set. Finally, he returns: filthy, soaked to the bone, and shivering, cradling the lost item in his arms like a wounded child.\n" +
			"He does not speak. He does not look up. He just drops it at your feet, then collapses on the floor in a heap of breath and regret. Whatever comfort the drink once gave him has long since fled."
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'ll teach him.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Item.getIcon(),
					text = "You gain " + _event.m.Item.getName(),
				});
				_event.m.Drunkard.worsenMood(2.5, "Had to search for " + _event.m.Item.getName() + " all day");
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Drunkard.getMoodState()],
					text = _event.m.Drunkard.getName() + ::Const.MoodStateEvent[_event.m.Drunkard.getMoodState()]
				});
				::World.Assets.getStash().add(_event.m.Item);
			}
		});
	}
});
