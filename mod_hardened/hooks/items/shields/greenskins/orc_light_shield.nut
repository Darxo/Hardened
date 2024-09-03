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
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 25;
		this.m.StaminaModifier = -20;
		this.m.ConditionMax = 24;
		this.m.FatigueOnSkillUse = 5;
	}

	// Overwrite because Reforged skill preview does not work with removing skills
	q.onEquip = @() function()
	{
		this.shield.onEquip();
		this.addSkill(::new("scripts/skills/actives/shieldwall"));
		// this.addSkill(::new("scripts/skills/actives/knock_back"));
	}
});

/*
Vanilla
	Orc Young

Reforged
	Orc Young
*/
