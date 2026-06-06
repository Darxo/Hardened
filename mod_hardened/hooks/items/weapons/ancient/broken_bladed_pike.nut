::Hardened.HooksMod.hook("scripts/items/weapons/ancient/broken_bladed_pike", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.addWeaponType(::Const.Items.WeaponType.Spear, true);
	}
});
