/// This Vanilla Anatomist effect implemenets its discount via the ::Const.Combat.WeaponSpecFatigueMult
/// Since we set that to 1.0 in Hardened, we also disable this Vanilla effect and need to reactivate it
::Hardened.HooksMod.hook("scripts/skills/effects/skeleton_warrior_potion_effect", function(q) {
	q.m.HD_ShieldwallFatigueMult <- 0.75;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/special.png")
			{
				entry.icon = "ui/icons/fatigue.png";	// More fitting for the type of effect
				entry.text = ::Reforged.Mod.Tooltips.parseString("[Shieldwall|Skill+shieldwall] costs " + ::MSU.Text.colorizeMultWithText(this.m.HD_ShieldwallFatigueMult, {InvertColor = true}) + " [Fatigue|Concept.Fatigue]");
			}
		}

		return ret;
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.m.HD_ShieldwallFatigueMult != 1.0)
		{
			local shieldwallSkill = this.getContainer().getSkillByID("actives.shieldwall");

			if (shieldwallSkill != null)
			{
				shieldwallSkill.m.FatigueCostMult *= this.m.HD_ShieldwallFatigueMult;
			}
		}
	}
});
