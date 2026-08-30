::Hardened.HooksMod.hook("scripts/entity/world/locations/legendary/unique_goblin_city_location", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		if (::World.Flags.get("IsGoblinCityOutposts"))
		{
			ret.push({
				id = 25,
				type = "text",
				icon = "ui/tooltips/scroll_01.png",
				text = ::World.Flags.get("GoblinCityCount") + "/5 Goblin Locations destroyed",
			});
		}

		if (::World.Flags.get("IsGoblinCityScouts"))
		{
			ret.push({
				id = 25,
				type = "text",
				icon = "ui/tooltips/scroll_01.png",
				text = ::World.Flags.get("GoblinCityCount") + "/10 Goblin Patrols defeated",
			});
		}

		return ret;
	}}.getTooltip;
});
