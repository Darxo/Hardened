::Hardened.HooksMod.hook("scripts/items/armor/ragged_surcoat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 90;				// In Vanilla this is 100
		this.m.ConditionMax = 50;		// In Vanilla this is 55
		this.m.StaminaModifier = -7; 	// In Vanilla this is -6
	}
});
