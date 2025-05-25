// Since All types of unhold inherit from the base unhold script, the following will affect all unhold variants
::Hardened.HooksMod.hookTree("scripts/entity/tactical/enemies/unhold", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.rf_rattle");		// Remove Full Force
		this.getSkills().removeByID("perk.rf_dismantle");	// Remove Dismantle
	}
});

