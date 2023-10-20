::mods_hookExactClass("skills/actives/stab", function(o) {
	local oldCreate = o.create;
	o.create = function()
	{
		oldCreate();
		this.m.ActionPointCost = 3;
	}
});
