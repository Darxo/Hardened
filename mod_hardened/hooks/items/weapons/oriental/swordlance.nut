::Hardened.HooksMod.hook("scripts/items/weapons/oriental/swordlance", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.removeWeaponType(::Const.Items.WeaponType.Sword);
	}
});
