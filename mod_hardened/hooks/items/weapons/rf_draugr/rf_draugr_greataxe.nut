::Hardened.HooksMod.hook("scripts/items/weapons/rf_draugr/rf_draugr_greataxe", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Same State as Great Axe, except Value, StaminaModifier and Reach
		this.m.Value = 2800;				// Reforged: 2000
		this.m.RegularDamage = 80;			// Reforged: 80
		this.m.RegularDamageMax = 100;		// Reforged: 95
		this.m.ShieldDamage = 32;			// Reforged: 40
		this.m.ConditionMax = 80.0;			// Reforged: 88.0
		this.m.StaminaModifier = -18;		// Reforged: -16
		this.m.ArmorDamageMult = 1.5;		// Reforged: 1.5
		this.m.DirectDamageMult = 0.4;		// Reforged: 0.4
		this.m.DirectDamageAdd = 0.0;		// Reforged: 0.05
		this.m.ChanceToHitHead = 0;			// Reforged: 5

		this.m.Reach = 6;					// Reforged: 5
	}
});
