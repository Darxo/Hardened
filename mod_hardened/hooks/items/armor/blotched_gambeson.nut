::Hardened.HooksMod.hook("scripts/items/armor/blotched_gambeson", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 130;				// In Vanilla this is 160
		// this.m.ConditionMax = 70; 	// In Vanilla this is 70
		this.m.StaminaModifier = -10; 	// In Vanilla this is -8
	}
});
