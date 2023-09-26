::mods_hookExactClass("skills/actives/ghost_swing_skill", function(o) {

	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.IsIgnoringArmorReduction = true;
	}
});
