::Hardened.HooksMod.hook("scripts/skills/actives/rf_swordmaster_stance_reverse_grip_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/rf_reach.png")
			{
				entry.icon = "ui/icons/special.png";	// Reforged uses the reach icon here
				// We completely rework the Reforged perk Concussive Strikes, so we need to adjust its name here too
				entry.text = ::MSU.String.replace(entry.text, "Concussive Strikes", "Shockwave");
			}
		}

		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Your equipped Sword also qualifies as a Mace"),
		});

		return ret;
	}
});
