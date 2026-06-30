::Hardened.HooksMod.hook("scripts/items/armor/executioner_tunic", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 80;				// Vanilla: 55
		this.m.ConditionMax = 50; 		// Vanilla: 25
		this.m.StaminaModifier = -8; 	// Vanilla: 0
	}
});
