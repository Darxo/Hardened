::Hardened.HooksMod.hook("scripts/skills/actives/adrenaline_skill", function(q) {
	// Overwrite, because we put all information inside the nested tooltip of the adrenaline rush effect
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [$ $|Skill+adrenaline_effect]"),
		});

		return ret;
	}}.getTooltip;
});
