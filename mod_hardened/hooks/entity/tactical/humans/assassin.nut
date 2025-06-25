::Hardened.HooksMod.hook("scripts/entity/tactical/humans/assassin", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();

		// Assassins now use a nightowl potion during night to allow them to see far enough to throw their pots
		this.getSkills().add(::new("scripts/skills/actives/fake_drink_night_vision_skill"));

		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_scout"));		// This allows them to see further which should help with their decision making during night

		this.getSkills().removeByID("perk.footwork");	// The have Ghostlike afterall to escape from melee
	}
});
