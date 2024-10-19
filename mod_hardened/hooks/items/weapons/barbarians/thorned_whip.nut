::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/thorned_whip", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 600				// In Vanilla this is 400
		this.m.ConditionMax = 25;		// In Vanilla this is 40
		this.m.StaminaModifier = -10;	// In Vanilla this is -6
		this.m.RegularDamage = 20;		// In Vanilla this is 15
		this.m.RegularDamageMax = 35;	// In Vanilla this is 25
	}
});
