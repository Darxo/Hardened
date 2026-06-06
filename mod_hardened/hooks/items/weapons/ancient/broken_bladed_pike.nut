::Hardened.HooksMod.hook("scripts/items/weapons/ancient/broken_bladed_pike", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ArmorDamageMult = 1.3;	// Vanilla: 0.8

		this.addWeaponType(::Const.Items.WeaponType.Spear, true);
	}
});
