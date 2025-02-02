::Hardened.HooksMod.hook("scripts/entity/world/location", function(q) {
	q.m.TemporarilyShowingName <- false;	// is this location currently displaying its name?

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		if (!this.isAlliedWithPlayer())
		{
			if (!this.m.IsShowingDefenders)
			{
				ret.push({
					id = 30,
					type = "hint",
					icon = "ui/orientation/player_01_orientation.png",
					text = "This location does not show defender",
				});
			}
			else if (this.m.HideDefenderAtNight)
			{
				ret.push({
					id = 30,
					type = "hint",
					icon = "skills/status_effect_35.png",
					text = "This location does not show defender during night",
				});
			}
		}
		return ret;
	}
});
