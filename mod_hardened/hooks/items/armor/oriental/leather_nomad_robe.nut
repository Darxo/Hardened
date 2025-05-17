::Hardened.HooksMod.hook("scripts/items/armor/oriental/leather_nomad_robe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 150;				// In Vanilla this is 140
		this.m.ConditionMax = 70; 		// In Vanilla this is 65
		this.m.StaminaModifier = -8; 	// In Vanilla this is -7
	}
});
