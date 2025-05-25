::Hardened.HooksMod.hook("scripts/entity/tactical/humans/barbarian_chosen", function(q) {	// Barbarian King
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));	// This will grant them immunity to disarm
	}
});
