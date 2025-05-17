::Hardened.HooksMod.hook("scripts/items/armor/mail_hauberk", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 1000;			// In Vanilla this is 1000
		this.m.ConditionMax = 170; 		// In Vanilla this is 150
		this.m.StaminaModifier = -21;	// In Vanilla this is -18
	}
});
