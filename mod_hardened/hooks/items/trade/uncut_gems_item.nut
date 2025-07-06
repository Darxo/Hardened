::Hardened.HooksMod.hook("scripts/items/trade/uncut_gems_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.HD_IsMineral = true;
	}
});
