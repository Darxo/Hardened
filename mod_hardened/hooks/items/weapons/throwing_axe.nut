::Hardened.HooksMod.hook("scripts/items/weapons/throwing_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RangeIdeal = 3;			// In Vanilla this is 4

		this.m.Value = 400;				// In Vanilla this is 200
		this.m.StaminaModifier = 0;		// In Vanilla this is -4
		this.m.RegularDamage = 35;		// In Vanilla this is 25
		this.m.RegularDamageMax = 50;	// In Vanilla this is 40
		this.m.ChanceToHitHead = 10;	// In Vanilla this is 5
		this.m.AdditionalAccuracy -= 10;	// In Vanilla this is 0

		this.m.AmmoWeight = 2.0;
	}
});
