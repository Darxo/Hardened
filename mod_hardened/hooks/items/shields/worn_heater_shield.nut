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
		this.m.Value = 250;		// In vanilla this is 150
		this.m.MeleeDefense = 23;
		this.m.RangedDefense = 13;
	}

	// Overwrite because Reforged skill preview does not work with removing skills
	q.onEquip = @() function()
	{
		this.shield.onEquip();
		// this.addSkill(::new("scripts/skills/actives/shieldwall"));
		this.addSkill(::new("scripts/skills/actives/knock_back"));
	}
});

/*
Vanilla
	Zombie Knight
	Armored Wiederganger

Reforged
*/
