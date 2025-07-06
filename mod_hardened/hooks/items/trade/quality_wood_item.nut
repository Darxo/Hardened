::Hardened.HooksMod.hook("scripts/items/trade/quality_wood_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.HD_IsBuildingSupply = true;
	}
});
