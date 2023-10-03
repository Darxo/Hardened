::mods_hookExactClass("entity/tactical/enemies/rf_bandit_bandit", function(o) {
	local oldOnInit = o.onInit;
	o.onInit = function()
	{
		oldOnInit();
		local tattoo_head = this.getSprite("tattoo_head");
		tattoo_head.setBrush("warpaint_0" + ::Math.rand(2, 3) + "_head");
		tattoo_head.Visible = true;
	}
});
