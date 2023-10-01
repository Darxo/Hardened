::mods_hookExactClass("items/weapons/pike", function(o) {
	local create = o.create;
	o.create = function()
	{
		create();
		this.addWeaponType(::Const.Items.WeaponType.Spear);
	}
});
