::Hardened.HooksMod.hook("scripts/items/weapons/rf_draugr/rf_draugr_cleaver", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Same State as Military Cleaver, except RegularDamageMax and Reach
		this.m.ConditionMax = 80.0;			// Reforged: 60.0
		this.m.StaminaModifier = -12;		// Reforged: -10
		this.m.Value = 1900;				// Reforged: 650
		this.m.RegularDamage = 45;			// Reforged: 30
		this.m.RegularDamageMax = 55;		// Reforged: 45
		this.m.ArmorDamageMult = 0.85;		// Reforged: 0.8
		this.m.DirectDamageMult = 0.25;		// Reforged: 0.3
		this.m.DirectDamageAdd = 0.0;		// Reforged: 0.05

		this.m.Reach = 4;		// Reforged: 3
	}
});
