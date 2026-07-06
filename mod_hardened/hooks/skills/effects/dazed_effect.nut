::Hardened.HooksMod.hook("scripts/skills/effects/dazed_effect", function(q) {
	q.m.NonAttackFatigueMult <- 1.25;
	q.m.DamageTotalMult <- 0.8;		// Vanilla: 0.75
	q.m.InitiativeMult <- 0.75;		// Vanilla: 0.75

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

	// Overwrite, because we disable two vanilla effects and remove the sprite that's turned on by vanilla
	q.onUpdate = @() function( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.getCurrentProperties().IsImmuneToDaze)
		{
			this.removeSelf();
		}
		else
		{
			_properties.DamageTotalMult *= this.m.DamageTotalMult;
			_properties.InitiativeMult *= this.m.InitiativeMult;
		}
	}

	q.onAfterUpdate <- function( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.getCurrentProperties().IsImmuneToDaze) return;

		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (!skill.isAttack())
			{
				// Feat: new effect that replaces the vanilla stamina mult
				skill.m.FatigueCostMult *= this.m.NonAttackFatigueMult;
			}
		}
	}

// Reforged Functions
	// Overwrite, because we want to disable any sprite display originating from this skill
	q.updateSprite = @() function() {}
});
