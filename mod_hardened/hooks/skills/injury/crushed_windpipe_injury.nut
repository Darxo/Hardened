::Hardened.HooksMod.hook("scripts/skills/injury/crushed_windpipe_injury", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 11 && entry.text.find("]-50%[") != null)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("[Recover|Skill+recover_skill] can no longer be used");
				break;
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// Crushed Windpipe no longer reduces the Stamina of the character
		local oldStaminaMult = _properties.StaminaMult;
		__original(_properties);
		_properties.StaminaMult = oldStaminaMult;

		// Crushed Windpipe now also disables the use of Recover
		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

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
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because of " + ::Reforged.NestedTooltips.getNestedSkillName(this)),
			});
		}
	}
});
