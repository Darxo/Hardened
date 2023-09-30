::mods_hookExactClass("skills/actives/slash", function(o) {
	local create = o.create;
	o.create = function()
	{
		create();
		this.m.HitChanceBonus = 0;
	}
});
