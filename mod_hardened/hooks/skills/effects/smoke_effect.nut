::Hardened.HooksMod.hook("scripts/skills/effects/smoke_effect", function(q) {
	q.m.RangedSkillMult <- 0.5;		// This value is currently just cosmetic

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();
		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/ranged_skill.png")
			{
				// We replace a single line of the vanilla tooltip without touching the rest
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.RangedSkillMult) + " [Ranged Skill|Concept.RangeSkill]");
				break;
			}
		}
		return ret;
	}}.getTooltip;

	q.onNewRound = @(__original) function()
	{
		// Vanilla Fix: Vanilla crashes the game, if the smoke effect lingers on an enemy for some reason beyond them still being on the map
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			this.removeSelf();
		}
		else
		{
			__original();
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// Vanilla Fix: Vanilla crashes the game, if the smoke effect lingers on an enemy for some reason beyond them still being on the map
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			this.removeSelf();
		}
		else
		{
			__original(_properties);
		}
	}
});
