::Hardened.HooksMod.hook("scripts/items/shields/worn_heater_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -14;
		this.m.ConditionMax = 24;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Zombie Knight
	Armored Wiederganger

Reforged
*/
