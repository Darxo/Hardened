::Hardened.HooksMod.hook("scripts/skills/injury_permanent/collapsed_lung_part_injury", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 7)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("[Recover|Skill+recover_skill] can no longer be used");
				break;
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// Collapsed Lung no longer reduces the Stamina of the character by 60%
		local oldStaminaMult = _properties.StaminaMult;
		__original(_properties);
		_properties.StaminaMult = oldStaminaMult;

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		// Collapsed Lung now also disables the use of Recover
		local recoverSkill = this.getContainer().getSkillByID("actives.recover");
		if (recoverSkill != null)
		{
			recoverSkill.m.IsUsable = false;
			this.getContainer().getActor().setDirty(true);	// Update the UI so that Recover is instantly shown as disabled
		}
	}

// MSU Events
	q.onQueryTooltip <- function( _skill, _tooltip )
	{
		if (_skill.getID() == "actives.recover")
		{
			local extraData = "entityId:" + this.getContainer().getActor().getID();
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because of " + ::Reforged.NestedTooltips.getNestedSkillName(this, extraData)),
			});
		}
	}
});
