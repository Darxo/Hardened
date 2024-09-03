::Hardened.HooksMod.hook("scripts/items/shields/legendary/gilders_embrace_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 25;
		this.m.RangedDefense = 25;
		this.m.StaminaModifier = -16;
		this.m.Condition = 786;
		this.m.ConditionMax = 786;

	// Hardened Adjustments
	}
});
