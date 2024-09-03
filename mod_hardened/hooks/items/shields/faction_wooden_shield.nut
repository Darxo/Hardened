::Hardened.HooksMod.hook("scripts/items/shields/faction_wooden_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -10;
		this.m.ConditionMax = 24;

	// Hardened Adjustments
	}
});

/*
Vanilla
	-

Reforged
	-
*/
