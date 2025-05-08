::Hardened.HooksMod.hook("scripts/items/shields/buckler_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 10;
		this.m.RangedDefense = 5;
		this.m.StaminaModifier = -4;
		this.m.ConditionMax = 16;

	// Hardened Adjustments
		this.m.StaminaModifier = -2;	// In Vanilla this is -4
	}
});

/*
Vanilla
	Low Raider
	Caravan Hand
	Militia

Reforged
	Bandit Scoundrel
*/
