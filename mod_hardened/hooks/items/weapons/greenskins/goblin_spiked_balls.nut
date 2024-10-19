::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_spiked_balls", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;				// In Vanilla this is 150
		this.m.StaminaModifier = 0;		// In Vanilla this is -3
		this.m.RegularDamage = 25;		// In Vanilla this is 20
		this.m.RegularDamageMax = 40;	// In Vanilla this is 35

		this.m.AmmoWeight = 1.5;
	}
});
