::Hardened.HooksMod.hook("scripts/items/weapons/rf_draugr/rf_draugr_voulge", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Same State as Great Axe, except Value, RegularDamageMax, StaminaModifier and Reach
		this.m.Value = 1600;				// Reforged: 2000
		this.m.RegularDamage = 60;			// Reforged: 55
		this.m.RegularDamageMax = 85;		// Reforged: 70
		this.m.ConditionMax = 64.0;			// Reforged: 60.0
		this.m.StaminaModifier = -16;		// Reforged: -10
		this.m.ArmorDamageMult = 1.2;		// Reforged: 1.2
		this.m.DirectDamageMult = 0.3;		// Reforged: 0.3
		this.m.DirectDamageAdd = 0.0;		// Reforged: 0.05
		this.m.ChanceToHitHead = 5;			// Reforged: 10

		this.m.Reach = 7;					// Reforged: 6
	}
});
