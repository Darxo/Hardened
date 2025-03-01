::Hardened.HooksMod.hook("scripts/skills/injury/cut_throat_injury", function(q) {
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

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		if (::Tactical.isActive())
		{
			local vanillaDamagePerRound = 6;
			local bleed = ::new("scripts/skills/effects/bleeding_effect");
			for (local i = 1; i <= vanillaDamagePerRound; ++i)
			{
				this.getContainer().getActor().getSkills().add(bleed);
			}
		}
	}

	q.applyDamage = @() function()	// This injury no longer applies any damage
	{
	}
});
