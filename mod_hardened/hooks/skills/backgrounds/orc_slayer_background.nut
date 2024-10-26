::Hardened.HooksMod.hook("scripts/skills/backgrounds/orc_slayer_background", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = "This character will leave your company when the Greenskin Crisis ends and share all his current experience between your remaining brothers",
		});

		return ret;
	}
});
