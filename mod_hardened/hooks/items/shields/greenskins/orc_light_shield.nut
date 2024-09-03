::Hardened.HooksMod.hook("scripts/items/shields/greenskins/orc_light_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -12;
		this.m.ConditionMax = 16;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Orc Young

Reforged
	Orc Young
*/
