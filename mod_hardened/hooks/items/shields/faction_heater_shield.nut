::Hardened.HooksMod.hook("scripts/items/shields/faction_heater_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -14;
		this.m.ConditionMax = 32;

	// Hardened Adjustments
		this.m.Value = 400;		// In Vanilla this is 250
		// Now it's an more of a combat shield (higher tier buckler) and less of a line-shield
		this.m.MeleeDefense = 25;
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
