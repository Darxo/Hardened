::Hardened.HooksMod.hook("scripts/skills/effects/dazed_effect", function(q) {
	q.m.NonAttackFatigueMult <- 1.25;
	q.m.DamageTotalMult <- 0.8;		// Vanilla: 0.75

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11)
			{
				entry.text = "Deal " + ::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " damage";
			}
			else if (entry.id == 12 && entry.icon == "ui/icons/fatigue.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Non-Attack skills cost " + ::MSU.Text.colorizeMultWithText(this.m.NonAttackFatigueMult, {InvertColor = true}) + " [Fatigue|Concept.Fatigue]");
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local oldDamageTotalMult = _properties.DamageTotalMult;
		local oldStaminaMult = _properties.StaminaMult;
		__original(_properties);
		_properties.DamageTotalMult = oldDamageTotalMult;
		_properties.StaminaMult = oldStaminaMult;	// Revert any changes to StaminaMult

		local actor = this.getContainer().getActor();
		if (actor.getCurrentProperties().IsImmuneToDaze) return;

		_properties.DamageTotalMult *= this.m.DamageTotalMult;
	}

	q.onAfterUpdate <- function( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.getCurrentProperties().IsImmuneToDaze) return;

		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (!skill.isAttack())
			{
				skill.m.FatigueCostMult *= this.m.NonAttackFatigueMult;
			}
		}
	}
});
