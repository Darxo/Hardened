::Hardened.HooksMod.hook("scripts/items/shields/greenskins/goblin_light_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 10;
		this.m.RangedDefense = 10;
		this.m.StaminaModifier = -4;
		this.m.ConditionMax = 12;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Goblin Fighter Low
	Goblin Fighter

Reforged
	-
*/
