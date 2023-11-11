::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_bandit", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		local tattoo_head = this.getSprite("tattoo_head");
		tattoo_head.setBrush("warpaint_0" + ::Math.rand(2, 3) + "_head");
		tattoo_head.Visible = true;
	}
});
