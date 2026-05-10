::Hardened.HooksMod.hook("scripts/items/weapons/ancient/warscythe", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1000;			// Vanilla: 700
		this.m.RegularDamageMax = 75;	// Vanilla: 80
		this.m.ArmorDamageMult = 1.2;	// Vanilla: 1.05

		this.addWeaponType(::Const.Items.WeaponType.Spear, true);
	}
});
