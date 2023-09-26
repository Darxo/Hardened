::mods_hookExactClass("skills/actives/ghastly_touch", function(o) {

	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.IsIgnoringArmorReduction = true;
	}
});
