::Hardened.HooksMod.hook("scripts/skills/effects/overwhelmed_effect", function(q) {
	q.m.HD_MeleeSkillPctPerStack <- -0.1;
	q.m.HD_RangedSkillPctPerStack <- -0.1;

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/melee_skill.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.getMeleeSkillMult()) + " [Melee Skill|Concept.MeleeSkill]");
			}
			else if (entry.id == 11 && entry.icon == "ui/icons/ranged_skill.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.getRangedSkillMult()) + " [Ranged Skill|Concept.RangeSkill]");
			}
		}

		return ret;
	}}.getTooltip;

// New Functions
	q.getMeleeSkillMult <- function()
	{
		return ::Math.maxf(0.0, 1.0 + this.m.Count * this.m.HD_MeleeSkillPctPerStack);
	}

	q.getRangedSkillMult <- function()
	{
		return ::Math.maxf(0.0, 1.0 + this.m.Count * this.m.HD_RangedSkillPctPerStack);
	}
});
