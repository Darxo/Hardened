::Hardened.HooksMod.hook("scripts/items/armor/gambeson", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 150;			// In Vanilla this is 150
		this.m.ConditionMax = 70; 		// In Vanilla this is 65
		this.m.StaminaModifier = -9; 	// In Vanilla this is -6
	}
});
