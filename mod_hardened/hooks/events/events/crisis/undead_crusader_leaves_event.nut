::Hardened.HooksMod.hook("scripts/events/events/crisis/undead_crusader_leaves_event", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Hook Crusader Leave event to make it so he shares all of his experience with all remaining brothers
		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "A")
			{
				local oldStart = screen.start;
				screen.start = function( _event )
				{
					local broXP = _event.m.Dude.getXP();

					oldStart(_event);

					local xpPerBrother = ::Hardened.util.shareExperience(broXP, 1.0);
					this.List.push({
						id = 14,
						icon = "ui/icons/xp_received.png",
						text = " Every brother gains " + ::MSU.Text.colorPositive("+" + xpPerBrother) + " Experience",
					});
				}
				break;
			}
		}
	}
});
