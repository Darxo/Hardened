::Hardened.HooksMod.hook("scripts/items/armor/mail_shirt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 800;				// In Vanilla this is 650
		this.m.ConditionMax = 150; 		// In Vanilla this is 130
		this.m.StaminaModifier = -18; 	// In Vanilla this is -14
	}
});
