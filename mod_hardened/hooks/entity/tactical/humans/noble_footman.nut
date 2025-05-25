::Hardened.HooksMod.hook("scripts/entity/tactical/humans/noble_footman", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.shield_expert");
		this.getSkills().removeByID("perk.rf_exploit_opening");
	}
});
