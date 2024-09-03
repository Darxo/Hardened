::Hardened.HooksMod.hook("scripts/items/shields/beasts/schrat_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = 0;
		this.m.ConditionMax = 32;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Schrat

Reforged
	-
*/
