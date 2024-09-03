::Hardened.HooksMod.hook("scripts/items/shields/oriental/southern_light_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -10;
		this.m.ConditionMax = 18;

	// Hardened Adjustments
		this.m.StaminaModifier = -8;
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
	Zombie Nomad
	Conscript
	Nomad Cutthroat
	Nomad Outlaw

Reforged
	Swordmaster (because of the swordmaster perk)
*/
