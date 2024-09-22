::Hardened.HooksMod.hook("scripts/items/weapons/staff_sling", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.removeWeaponType(::Const.Items.WeaponType.Sling);
	}
});
