::Hardened.HooksMod.hook("scripts/skills/effects/withered_effect", function(q) {
	q.m.NonAttackFatigueMultPct <- 0.50;	// Non-Attacks cost this much more per turn left on this effect
	q.m.DamageTotalPctPerTurn <- -0.25;
	q.m.InitiativePctPerTurn <- -0.25;

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

	// Overwrite, because we disable stamina, fatigue recovery and remove the sprite that's turned on by vanilla
	q.onUpdate = @() function( _properties )
	{
		_properties.DamageTotalMult *= this.HD_getDamageTotalMult();
		_properties.InitiativeMult *= this.HD_getInitiativeMult();
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
		return ::Math.maxf(0.0, 1.0 + this.m.TurnsLeft * this.m.NonAttackFatigueMultPct);
	}

	q.HD_getDamageTotalMult <- function()
	{
		return ::Math.maxf(0.0, 1.0 + this.m.TurnsLeft * this.m.DamageTotalPctPerTurn);
	}

	q.HD_getInitiativeMult <- function()
	{
		return ::Math.maxf(0.0, 1.0 + this.m.TurnsLeft * this.m.InitiativePctPerTurn);
	}
});
