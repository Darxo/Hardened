::Hardened.HooksMod.hook("scripts/items/armor/oriental/thick_nomad_robe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 100;			// In Vanilla this is 100
		// this.m.ConditionMax = 50; 	// In Vanilla this is 50
		this.m.StaminaModifier = -6; 	// In Vanilla this is -5
	}
});
