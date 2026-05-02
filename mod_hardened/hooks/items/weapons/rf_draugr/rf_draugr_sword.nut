::Hardened.HooksMod.hook("scripts/items/weapons/rf_draugr/rf_draugr_sword", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Same State as Arming Sword, except RegularDamage, RegularDamageMax and Reach
		this.m.ConditionMax = 72.0;			// Reforged: 52.0
		this.m.StaminaModifier = -8;		// Reforged: -6
		this.m.Value = 3000;				// Reforged: 1000
		this.m.RegularDamage = 42;			// Reforged: 40
		this.m.RegularDamageMax = 47;		// Reforged: 45
		this.m.ArmorDamageMult = 0.85;		// Reforged: 0.8
		this.m.DirectDamageMult = 0.2;		// Reforged: 0.2

		this.m.Reach = 5;		// Reforged: 5
	}
});
