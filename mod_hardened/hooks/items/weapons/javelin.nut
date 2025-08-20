::Hardened.HooksMod.hook("scripts/items/weapons/javelin", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 350;				// In Vanilla this is 200
		this.m.StaminaModifier = 0;		// In Vanilla this is -6
		this.m.RegularDamage = 35;		// In Vanilla this is 30
		// RegularDamageMax = 45 in Vanilla
		this.m.ArmorDamageMult = 0.7;	// In Vanilla this is 0.75

		this.m.AmmoCost = 2;			// Vanilla: 3
		this.m.AmmoWeight = 2.0;
	}
});
