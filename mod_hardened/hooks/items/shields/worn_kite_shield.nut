::Hardened.HooksMod.hook("scripts/items/shields/worn_kite_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -16;
		this.m.ConditionMax = 40;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Zombie Knight

Reforged
*/
