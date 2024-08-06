::Hardened.HooksMod.hook("scripts/skills/effects/distracted_effect", function(q) {
	q.m.DamageTotalMult <- 0.80;
	q.m.InitiativeMult <- 0.65;

	// Overwrite of Vanilla function to stop its effects and apply our own
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11)
			{
				entry.text = "Deal " + ::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " damage";
				break;
			}
		}

		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Does not exert [Zone of Control|Concept.ZoneOfControl]"),
		});

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local oldDamageTotalMult = _properties.DamageTotalMult;
		__original(_properties);
		_properties.DamageTotalMult = oldDamageTotalMult;

		_properties.DamageTotalMult *= this.m.DamageTotalMult;
		_properties.CanExertZoneOfControl = false;
	}

});
