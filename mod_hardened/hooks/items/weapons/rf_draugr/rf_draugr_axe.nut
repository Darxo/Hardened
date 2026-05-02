::Hardened.HooksMod.hook("scripts/items/weapons/rf_draugr/rf_draugr_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Same State as Fighting Axe, except RegularDamageMax and Reach
		this.m.Value = 2300;			// Reforged: 800
		this.m.ShieldDamage = 16;		// Reforged: 14
		this.m.ConditionMax = 80.0;		// Reforged: 76
		this.m.StaminaModifier = -12;	// Reforged: -12
		this.m.RegularDamage = 35;		// Reforged: 30
		this.m.RegularDamageMax = 50;	// Reforged: 45
		this.m.ArmorDamageMult = 1.3;	// Reforged: 1.2
		this.m.DirectDamageMult = 0.3;	// Reforged: 0.30
		this.m.DirectDamageAdd = 0.0;	// Reforged: 0.05

		this.m.Reach = 4;		// Reforged: 3
	}
});
