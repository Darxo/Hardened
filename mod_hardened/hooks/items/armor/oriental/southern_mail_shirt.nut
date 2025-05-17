::Hardened.HooksMod.hook("scripts/items/armor/oriental/southern_mail_shirt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 400;			// In Vanilla this is 400
		// this.m.ConditionMax = 110; 	// In Vanilla this is 110
		this.m.StaminaModifier = -13; 	// In Vanilla this is -11
	}
});
