::Hardened.HooksMod.hook("scripts/entity/tactical/goblin", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		local bp = this.m.BaseProperties;

		// Goblins in Reforged have perma -1 Reach, which they had to offset with regular stats.
		// So in Hardened they lose some stats
		bp.MeleeSkill -= 5;
		bp.MeleeDefense -= 5;
	}

	q.onSpawned = @(__original) function()
	{
		this.getSkills().add(::new("scripts/skills/racial/hd_goblin_racial"));

		this.getSkills().removeByID("perk.pathfinder");
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_trip_artist"));	// Add Elusive perk as a replacement for Pathfinder
	}
});
