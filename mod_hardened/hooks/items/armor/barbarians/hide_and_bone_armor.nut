::Hardened.HooksMod.hook("scripts/items/armor/barbarians/hide_and_bone_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 250;				// In Vanilla this is 220
		this.m.ConditionMax = 100; 		// In Vanilla this is 95
		this.m.StaminaModifier = -15; 	// In Vanilla this is -10
	}
});
