::Hardened.HooksMod.hook("scripts/items/armor/oriental/mail_and_lamellar_plating", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2500;			// In Vanilla this is 750
		this.m.ConditionMax = 170; 		// In Vanilla this is 135
		this.m.StaminaModifier = -17; 	// In Vanilla this is -15
	}
});
