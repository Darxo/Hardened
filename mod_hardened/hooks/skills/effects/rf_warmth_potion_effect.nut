::Hardened.HooksMod.hook("scripts/skills/effects/rf_warmth_potion_effect", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 12 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Immune to [$ $|Skill+chilled_effect] and [$ $|Skill+rf_frostbound_effect]");
				break;
			}
		}

		return ret;
	}

	// Feat: we now implement the cold immunity from this effect by changing a character property
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.HD_ImmuneToChilled = true;
	}
});
