::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/ghoul", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.rf_deep_cuts");
	}
});
