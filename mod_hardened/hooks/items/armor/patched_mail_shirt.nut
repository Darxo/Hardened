::Hardened.HooksMod.hook("scripts/items/armor/patched_mail_shirt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 250;			// In Vanilla this is 250
		this.m.ConditionMax = 100; 		// In Vanilla this is 90
		this.m.StaminaModifier = -15; 	// In Vanilla this is -10
	}
});
