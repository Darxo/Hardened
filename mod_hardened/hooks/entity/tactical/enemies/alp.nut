::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/alp", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));	// Add 'Elusive' to this enemy
	}
});
