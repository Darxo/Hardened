::Hardened.HooksMod.hook("scripts/skills/injury/grazed_neck_injury", function(q) {
	// Public
	q.m.HD_BleedStacks <- 1;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (!this.m.IsShownOutOfCombat)
		{
			foreach (index, entry in ret)
			{
				if (entry.id == 7)
				{
					ret.remove(index);	// remove mention about damage over time effect
					break;
				}
			}
		}

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/damage_received.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorDamage(this.m.HD_BleedStacks) + " stacks of [Bleeding|Skill+bleeding_effect] when you receive this injury during combat"),
		});

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		if (::Tactical.isActive())
		{
			local bleed = ::new("scripts/skills/effects/bleeding_effect");
			for (local i = 1; i <= this.m.HD_BleedStacks; ++i)
			{
				this.getContainer().getActor().getSkills().add(bleed);
			}
		}
	}

	q.applyDamage = @() function()	// This injury no longer applies any damage
	{
	}
});
