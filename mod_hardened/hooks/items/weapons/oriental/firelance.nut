::Hardened.HooksMod.hook("scripts/items/weapons/oriental/firelance", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.addWeaponType(::Const.Items.WeaponType.Firearm, true);
	}
});
