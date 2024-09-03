::Hardened.HooksMod.hook("scripts/items/shields/worn_kite_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -16;
		this.m.ConditionMax = 40;

	// Hardened Adjustments
		this.m.MeleeDefense = 13;
		this.m.RangedDefense = 23;
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
	Zombie Knight

Reforged
*/
