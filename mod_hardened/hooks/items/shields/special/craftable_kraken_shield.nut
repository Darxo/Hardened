::Hardened.HooksMod.hook("scripts/items/shields/special/craftable_kraken_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 24;
		this.m.RangedDefense = 24;
		this.m.StaminaModifier = -15;
		this.m.ConditionMax = 50;

	// Hardened Adjustments
	}
});
