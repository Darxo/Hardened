::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_wolfrider", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();

		// Goblin Wolfrider gain Elusive because they inherit the regular Goblin, but we want them to keep Pathfinder, just like vanilla had
		this.getSkills().removeByID("perk.hd_elusive");
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
	}
});
