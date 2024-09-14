::Hardened.HooksMod.hook("scripts/items/shields/oriental/metal_round_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.ConditionMax = 60;
		this.m.MeleeDefense = 18;
		this.m.RangedDefense = 18;
		this.m.StaminaModifier = -18;

	// Hardened Adjustments
		this.m.Value = 450;		// In Vanilla this is 250
	}
});

/*
Vanilla
	Gladiator
	Nomad Leader
	Nomad Outlaw
	Officer

Reforged
	-
*/
