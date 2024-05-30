::Hardened.HooksMod.hook("scripts/items/armor_upgrades/rf_heraldic_cape_upgrade", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ResolveModifier = 10;
		this.m.ConditionModifier = 20;
		this.m.StaminaModifier = 0;
		this.m.Value = 1000;
	}
});
