::Hardened.HooksMod.hook("scripts/skills/effects/net_effect", function(q) {
	q.m.MeleeDefenseMult <- 0.5;	// In Vanilla this is 0.55
	q.m.RangedDefenseMult <- 0.5;	// In Vanilla this is 0.55
	q.m.InitiativeMult <- 1.0;		// In Vanilla this is 0.55

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		for (local index = ret.len() - 1; index >= 0; --index)
		{
			local entry = ret[index];
			if (entry.id == 10 && entry.icon == "ui/icons/melee_defense.png")
			{
				if (this.m.MeleeDefenseMult == 1.0)
				{
					ret.remove(index);	// We stop displaying lines if the attribute no longer changes
				}
				else
				{
					entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.MeleeDefenseMult) + " [Melee Defense|Concept.MeleeDefense]");
				}
			}
			else if (entry.id == 11 && entry.icon == "ui/icons/ranged_defense.png")
			{
				if (this.m.RangedDefenseMult == 1.0)
				{
					ret.remove(index);	// We stop displaying lines if the attribute no longer changes
				}
				else
				{
					entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.RangedDefenseMult) + " [Ranged Defense|Concept.RangeDefense]");
				}
			}
			else if (entry.id == 11 && entry.icon == "ui/icons/initiative.png")
			{
				if (this.m.InitiativeMult == 1.0)
				{
					ret.remove(index);	// We stop displaying lines if the attribute no longer changes
				}
				else
				{
					entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.InitiativeMult) + " [Initiative|Concept.Initiative]");
				}
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// Revert all hard-coded vanilla changes
		local oldMeleeDefenseMult = _properties.MeleeDefenseMult;
		local oldRangedDefenseMult = _properties.RangedDefenseMult;
		local oldInitiativeMult = _properties.InitiativeMult;
		__original(_properties);
		_properties.MeleeDefenseMult = oldMeleeDefenseMult;
		_properties.RangedDefenseMult = oldRangedDefenseMult;
		_properties.InitiativeMult = oldInitiativeMult;

		// Apply our own moddable changes
		_properties.MeleeDefenseMult *= this.m.MeleeDefenseMult
		_properties.RangedDefenseMult *= this.m.RangedDefenseMult
		_properties.InitiativeMult *= this.m.InitiativeMult
	}
});
