::mods_hookExactClass("items/weapons/ancient/bladed_pike", function(o) {
	local create = o.create;
	o.create = function()
	{
		create();
		this.addWeaponType(::Const.Items.WeaponType.Spear);
	}
});
