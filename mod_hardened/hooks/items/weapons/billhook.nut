::Hardened.HooksMod.hook("scripts/items/weapons/billhook", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.removeWeaponType(::Const.Items.WeaponType.Axe);
	}
});
