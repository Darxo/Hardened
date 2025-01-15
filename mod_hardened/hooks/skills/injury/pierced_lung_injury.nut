::Hardened.HooksMod.hook("scripts/skills/injury/pierced_lung_injury", function(q) {
	q.m.StaminaMult <- 0.7;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local positionToInsert = ret.len();		// Position where we want to inser the new tooltip
		foreach (index, entry in ret)
		{
			if (entry.id == 7)
			{
				// Adjust the tooltip mentioning the Stamina Multiplier
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.StaminaMult) + " [Stamina|Concept.MaximumFatigue]");
				positionToInsert = index + 1;
			}
		}

		ret.insert(positionToInsert, {
			id = 10,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::Reforged.Mod.Tooltips.parseString("[Recover|Skill+recover_skill] can no longer be used"),
		});

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// Pierced Lung no longer reduces the Stamina of the character by 60%
		local oldStaminaMult = _properties.StaminaMult;
		__original(_properties);
		_properties.StaminaMult = oldStaminaMult;

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		// Instead we apply our custom Stamina Multiplier
		_properties.StaminaMult *= this.m.StaminaMult;

		// Pierced Lung now also disables the use of Recover
		local recoverSkill = this.getContainer().getSkillByID("actives.recover");
		if (recoverSkill != null)
		{
			recoverSkill.m.IsUsable = false;
			this.getContainer().getActor().setDirty(true);	// Update the UI so that Recover is instantly shown as disabled
		}
	}

	q.onRemoved = @(__original) function()
	{
		__original();

		// Make sure that recover is usable again the moment that this injury is removed
		local recoverSkill = this.getContainer().getSkillByID("actives.recover");
		if (recoverSkill != null)
		{
			recoverSkill.m.IsUsable = true;
			this.getContainer().getActor().setDirty(true);	// Update the UI so that Recover is instantly shown as enabled
		}
	}

// MSU Events
	q.onQueryTooltip <- function( _skill, _tooltip )
	{
		if (_skill.getID() == "actives.recover")
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because of " + ::Reforged.NestedTooltips.getNestedSkillName(this)),
			});
		}
	}
});
