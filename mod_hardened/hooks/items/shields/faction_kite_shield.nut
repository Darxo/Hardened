::Hardened.HooksMod.hook("scripts/items/shields/faction_kite_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 25;
		this.m.StaminaModifier = -16;
		this.m.ConditionMax = 48;

	// Hardened Adjustments
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
	Knight
	Footman

Reforged
	Knight
	Footman
	Footman Heavy
	Knight Anointed
	Marshal
	Squire
*/
