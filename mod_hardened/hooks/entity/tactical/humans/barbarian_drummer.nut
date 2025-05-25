::Hardened.HooksMod.hook("scripts/entity/tactical/humans/barbarian_drummer", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		// Replace Survival Instinct with Base Defense to reduce bloat
		this.getSkills().removeByID("perk.rf_survival_instinct");
		local b = this.m.BaseProperties;
		b.MeleeDefense += 10;
		b.RangedDefense += 10;
	}
});
