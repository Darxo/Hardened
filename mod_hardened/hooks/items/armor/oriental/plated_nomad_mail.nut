::Hardened.HooksMod.hook("scripts/items/armor/oriental/plated_nomad_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;				// In Vanilla this is 350
		this.m.ConditionMax = 110; 		// In Vanilla this is 105
		this.m.StaminaModifier = -13; 	// In Vanilla this is -11
	}
});
