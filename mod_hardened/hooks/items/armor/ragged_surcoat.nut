::Hardened.HooksMod.hook("scripts/items/armor/ragged_surcoat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 100;			// In Vanilla this is 100
		this.m.ConditionMax = 60;		// In Vanilla this is 55
		this.m.StaminaModifier = -8; 	// In Vanilla this is -6
	}
});
