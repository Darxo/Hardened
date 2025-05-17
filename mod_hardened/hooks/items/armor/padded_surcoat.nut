::Hardened.HooksMod.hook("scripts/items/armor/padded_surcoat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 90;			// In Vanilla this is 90
		// this.m.ConditionMax = 50; 	// In Vanilla this is 50
		this.m.StaminaModifier = -7; 	// In Vanilla this is -4
	}
});
