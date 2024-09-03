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
