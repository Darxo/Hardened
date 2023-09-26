::mods_hookExactClass("skills/actives/ghost_overhead_strike", function(o) {

	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.IsIgnoringArmorReduction = true;
	}
});
