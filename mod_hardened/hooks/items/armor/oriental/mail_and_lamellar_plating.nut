::Hardened.HooksMod.hook("scripts/items/armor/oriental/mail_and_lamellar_plating", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 900;				// In Vanilla this is 750
		this.m.ConditionMax = 160; 		// In Vanilla this is 135
		this.m.StaminaModifier = -18; 	// In Vanilla this is -15
	}
});
