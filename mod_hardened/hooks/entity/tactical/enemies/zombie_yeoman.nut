::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_yeoman", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));	// Re-Add Overwhelm because it was removed from base zombie class
	}
});
