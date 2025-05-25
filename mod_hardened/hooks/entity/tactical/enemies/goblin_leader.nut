::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_leader", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/perks/perk_bullseye"));	// Manually re-add "Bullseye" after it has been removed from Goblin baseclass
	}
});
