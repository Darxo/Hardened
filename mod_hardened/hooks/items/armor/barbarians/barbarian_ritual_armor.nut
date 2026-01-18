::Hardened.HooksMod.hook("scripts/items/armor/barbarians/barbarian_ritual_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 320; 		// Vanilla: 300
		this.m.StaminaModifier = -32; 	// Vanilla: 30
	}
});
