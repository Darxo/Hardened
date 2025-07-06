::Hardened.HooksMod.hook("scripts/items/trade/copper_ingots_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.HD_IsBuildingSupply = true;
		this.m.HD_IsMineral = true;
	}
});
