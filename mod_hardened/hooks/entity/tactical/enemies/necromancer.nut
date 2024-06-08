::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/necromancer", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.m.Skills.removeByID("perk.inspiring_presence");
		this.m.Skills.add(::new("scripts/skills/perks/perk_rf_soul_link"));
	}
});
