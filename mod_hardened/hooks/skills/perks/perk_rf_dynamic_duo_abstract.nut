::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_dynamic_duo_abstract", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// Dynamic Duo Partner no longer gain melee stats when something happens to the other person
		this.m.MeleeSkillModifier = 0;
		this.m.MeleeDefenseModifier = 0;
	}
});

