::Hardened.HooksMod.hook("scripts/entity/tactical/humans/swordmaster", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.dodge");
		this.getSkills().add(::new("scripts/skills/perks/perk_reach_advantage"));	// Add "Parry" perk
	}
});
