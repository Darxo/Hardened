::Hardened.HooksMod.hook("scripts/skills/effects/dazed_effect", function(q) {
	q.m.NonAttackFatigueMult <- 1.25;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 12)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Non-attack skills cost " + ::MSU.Text.colorizeMultWithText(this.m.NonAttackFatigueMult, {InvertColor = true}) + " [Fatigue|Concept.Fatigue]");
				break;
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local oldStaminaMult = _properties.StaminaMult;
		__original(_properties);
		_properties.StaminaMult = oldStaminaMult;	// Revert any changes to StaminaMult
	}

	q.onAfterUpdate <- function( _properties )
	{
		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (!skill.isAttack())
			{
				skill.m.FatigueCostMult *= this.m.NonAttackFatigueMult;
			}
		}
	}
});
