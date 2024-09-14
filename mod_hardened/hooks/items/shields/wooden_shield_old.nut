::Hardened.HooksMod.hook("scripts/items/shields/wooden_shield_old", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -10;
		this.m.ConditionMax = 16;

	// Hardened Adjustments
		this.m.Value = 100;		// In Vanilla this is 60
		this.m.MeleeDefense = 13;
		this.m.RangedDefense = 13;
	}
});

/*
Vanilla
	Armored Wiederganger
	Barbarian Marauder
	Barbarian Thrall

Reforged
	-
*/
