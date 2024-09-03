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
