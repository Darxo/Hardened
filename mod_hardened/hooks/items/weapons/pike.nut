::Hardened.HooksMod.hook("scripts/items/weapons/pike", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.addWeaponType(::Const.Items.WeaponType.Spear);
	}
});
