::Hardened.HooksMod.hook("scripts/items/helmets/ancient/ancient_household_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 250;				// Vanilla: 250
		this.m.ConditionMax = 95;		// Vanilla: 95
		this.m.StaminaModifier = -8;	// Vanilla: -8
		this.m.Vision = -1;				// Vanilla: -1
	}
});
