::Hardened.HooksMod.hook("scripts/items/armor/oriental/cloth_sash", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 40;			// In Vanilla this is 40
		// this.m.ConditionMax = 20; 	// In Vanilla this is 20
		this.m.StaminaModifier = -2; 	// In Vanilla this is 0
	}
});
