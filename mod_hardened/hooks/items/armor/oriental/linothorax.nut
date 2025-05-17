::Hardened.HooksMod.hook("scripts/items/armor/oriental/linothorax", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 200;				// In Vanilla this is 180
		this.m.ConditionMax = 80; 		// In Vanilla this is 75
		this.m.StaminaModifier = -9; 	// In Vanilla this is -7
	}
});
