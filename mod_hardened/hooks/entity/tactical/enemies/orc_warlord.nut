::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/orc_warlord", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));	// This will grant them immunity to disarm
	}
});
