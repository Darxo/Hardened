::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_footman_heavy", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.rf_exploit_opening");
	}
});
