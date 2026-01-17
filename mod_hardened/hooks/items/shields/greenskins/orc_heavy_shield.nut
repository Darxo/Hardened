::Hardened.HooksMod.hook("scripts/items/shields/greenskins/orc_heavy_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -22;
		this.m.ConditionMax = 72;
		this.m.FatigueOnSkillUse = 5;

	// Hardened Adjustments
		this.m.Value = 600;		// In Vanilla this is 250
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -24;	// Vanilla: -22
	}
});

/*
Vanilla
	Orc Warrior

Reforged
	-
*/
