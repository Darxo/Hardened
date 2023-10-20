::mods_hookExactClass("skills/perks/perk_rf_pattern_recognition", function(o) {
	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.IconMini = "";
	}
});
