::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/ghost", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.fearsome");
		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));
	}
});
