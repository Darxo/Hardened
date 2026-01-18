::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/barbarian_ritual_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.ConditionMax = 310; 	// Vanilla: 300
		this.m.StaminaModifier = -20; 	// Vanilla: -28
	}
});
