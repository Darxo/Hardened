::Hardened.HooksMod.hook("scripts/skills/injury/cut_leg_muscles_injury", function(q) {
	q.m.HD_MeleeDefenseMult <- 0.7;		// Vanilla: 0.6
	q.m.HD_InitiativeMult <- 0.7;		// Vanilla: 0.6

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local positionToInsert = ret.len();		// Position where we want to inser the new tooltip
		foreach (index, entry in ret)
		{
			if (entry.id == 7 && entry.icon == "ui/icons/melee_defense.png")
			{
				// Adjust the tooltip mentioning the Stamina Multiplier
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.HD_MeleeDefenseMult) + " [Melee Defense|Concept.MeleeDefense]");
			}
			else if (entry.id == 7 && entry.icon == "ui/icons/initiative.png")
			{
				// Adjust the tooltip mentioning the Stamina Multiplier
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.HD_InitiativeMult) + " [Initiative|Concept.Initiative]");
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// Pierced Lung no longer reduces the Stamina of the character by 60%
		local oldMeleeDefenseMult = _properties.MeleeDefenseMult;
		local oldInitiativeMult = _properties.InitiativeMult;
		__original(_properties);
		_properties.MeleeDefenseMult = oldMeleeDefenseMult;
		_properties.InitiativeMult = oldInitiativeMult;

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		_properties.MeleeDefenseMult *= this.m.HD_MeleeDefenseMult;
		_properties.InitiativeMult *= this.m.HD_InitiativeMult;
	}
});
