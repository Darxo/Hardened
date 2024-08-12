::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_flaming_arrows", function(q) {
	q.onQueryTooltip = @(__original) function( _skill, _tooltip )
	{
		local ret = __original(_skill, _tooltip);

		if (_skill.getID() == "actives.aimed_shot")
		{
			ret.push({
				id = 102,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Burns away any [rooted|Rooted.StatusEffect] effects on the target"),
			});
		}

		return ret;
	}
});
