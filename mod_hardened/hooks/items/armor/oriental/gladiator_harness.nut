::Hardened.HooksMod.hook("scripts/items/armor/oriental/gladiator_harness", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 600;				// Vanilla: 150
		this.m.ConditionMax = 60; 		// Vanilla: 40
		this.m.StaminaModifier = -4; 	// Vanilla: -4
	}
});
