::Hardened.HooksMod.hook("scripts/items/shields/greenskins/goblin_heavy_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 10;
		this.m.RangedDefense = 10;
		this.m.StaminaModifier = -8;
		this.m.ConditionMax = 16;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Goblin Fighter

Reforged
	-
*/
