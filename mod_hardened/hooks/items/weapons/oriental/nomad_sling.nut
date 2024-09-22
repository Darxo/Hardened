::Hardened.HooksMod.hook("scripts/items/weapons/oriental/nomad_sling", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.removeWeaponType(::Const.Items.WeaponType.Sling);
	}
});
