::Hardened.HooksMod.hook("scripts/items/armor/oriental/assassin_robe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 1400;			// In Vanilla this is 1400
		this.m.ConditionMax = 80; 		// In Vanilla this is 120
		this.m.StaminaModifier = -4; 	// In Vanilla this is -9
	}
});
