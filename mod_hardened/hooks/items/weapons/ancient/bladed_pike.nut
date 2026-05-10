::Hardened.HooksMod.hook("scripts/items/weapons/ancient/bladed_pike", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 800;				// Vanilla: 600
		this.m.ConditionMax = 42;		// Vanilla: 30
		this.m.RegularDamageMax = 75;	// Vanilla: 80
		this.m.ArmorDamageMult = 1.3;	// Vanilla: 1.25

		this.addWeaponType(::Const.Items.WeaponType.Spear, true);
	}
});
