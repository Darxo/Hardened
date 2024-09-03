::Hardened.HooksMod.hook("scripts/items/shields/special/craftable_lindwurm_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 17;
		this.m.RangedDefense = 25;
		this.m.StaminaModifier = -14;
		this.m.ConditionMax = 64;

	// Hardened Adjustments
	}
});
