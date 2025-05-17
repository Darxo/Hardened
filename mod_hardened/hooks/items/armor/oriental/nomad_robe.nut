::Hardened.HooksMod.hook("scripts/items/armor/oriental/nomad_robe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 100;			// In Vanilla this is 100
		this.m.ConditionMax = 30; 		// In Vanilla this is 20
		this.m.StaminaModifier = -4; 	// In Vanilla this is -2
	}
});
