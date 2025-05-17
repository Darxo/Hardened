::Hardened.HooksMod.hook("scripts/items/armor/worn_mail_shirt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 350;				// In Vanilla this is 400
		// this.m.ConditionMax = 110; 	// In Vanilla this is 110
		this.m.StaminaModifier = -14; 	// In Vanilla this is -12
	}
});
