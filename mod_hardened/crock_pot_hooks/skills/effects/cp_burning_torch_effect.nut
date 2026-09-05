::Hardened.HooksMod.hook("scripts/skills/effects/cp_burning_torch_effect", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immune to [$ $|Skill+chilled_effect] and [$ $|Skill+rf_frostbound_effect]"),
		});

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// Feat: a burning torch now provides chill immunity
		_properties.HD_ImmuneToChilled = true;
	}
});
