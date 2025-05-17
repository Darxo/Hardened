::Hardened.HooksMod.hook("scripts/items/armor/oriental/stitched_nomad_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 200;			// In Vanilla this is 200
		// this.m.ConditionMax = 80; 	// In Vanilla this is 80
		this.m.StaminaModifier = -9; 	// In Vanilla this is -8
	}
});
