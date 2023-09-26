::mods_hookExactClass("skills/actives/ghost_split_skill", function(o) {

	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.IsIgnoringArmorReduction = true;
	}
});
