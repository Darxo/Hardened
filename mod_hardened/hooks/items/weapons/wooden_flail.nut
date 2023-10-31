::mods_hookExactClass("items/weapons/wooden_flail", function(o) {
	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.RegularDamage += 5;
		this.m.RegularDamageMax += 5;
		this.m.Value += 20;
	}
});
