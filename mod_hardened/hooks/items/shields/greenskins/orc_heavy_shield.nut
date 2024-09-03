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
	}
});

/*
Vanilla
	Orc Warrior

Reforged
	-
*/
