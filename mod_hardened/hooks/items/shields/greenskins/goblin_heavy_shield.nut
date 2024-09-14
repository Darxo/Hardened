::Hardened.HooksMod.hook("scripts/items/shields/greenskins/goblin_heavy_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 10;
		this.m.RangedDefense = 10;
		this.m.StaminaModifier = -8;
		this.m.ConditionMax = 16;

	// Hardened Adjustments
		this.m.Value = 65;		// In Vanilla this is 45
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
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
	Goblin Fighter

Reforged
	-
*/
