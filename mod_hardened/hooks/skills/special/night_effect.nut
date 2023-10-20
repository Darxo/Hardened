::mods_hookExactClass("skills/special/night_effect", function(o) {
	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.IconMini = "";
	}
});
