::Hardened.HooksMod.hook("scripts/items/armor/rusted_mail_hauberk", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1300;			// Vanilla: 650
		this.m.ConditionMax = 150; 		// Vanilla: 140
		this.m.StaminaModifier = -19;	// Vanilla: -18
	}
});
