::Hardened.HooksMod.hook("scripts/skills/effects/withered_effect", function(q) {
	q.m.NonAttackFatigueMultPct <- 0.50;	// Non-Attacks cost this much more per turn left on this effect

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 12 && entry.icon == "ui/icons/fatigue.png")	// Replace mention about stamina mult with new effect
			{
				ret.remove(index);	// Remove mention about Fatigue Recovery
				break;
			}
		}

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/fatigue.png")	// Replace mention about stamina mult with new effect
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Non-Attack skills cost " + ::MSU.Text.colorizeMultWithText(this.getNonAttackFatigueMult(), {InvertColor = true}) + " [Fatigue|Concept.Fatigue]");
				break;
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local oldStaminaMult = _properties.StaminaMult;
		local oldFatigueRecoveryRate = _properties.FatigueRecoveryRate;
		__original(_properties);
		_properties.StaminaMult = oldStaminaMult;	// Revert any changes to StaminaMult
		_properties.FatigueRecoveryRate = oldFatigueRecoveryRate;	// Revert any changes to FatigueRecoveryRate
	}

	q.onAfterUpdate <- function( _properties )
	{
		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (!skill.isAttack())
			{
				skill.m.FatigueCostMult *= this.getNonAttackFatigueMult();
			}
		}
	}

// New Functions
	q.getNonAttackFatigueMult <- function()
	{
		return 1.0 + this.m.TurnsLeft * this.m.NonAttackFatigueMultPct;
	}
});
