::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/lesser_flesh_golem", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.rf_rattle");		// Remove Full Force
	}
});
