::Hardened.HooksMod.hook("scripts/items/armor/basic_mail_shirt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 600;				// In Vanilla this is 450
		this.m.ConditionMax = 130; 		// In Vanilla this is 115
		this.m.StaminaModifier = -15; 	// In Vanilla this is -12
	}
});
