::Hardened.HooksMod.hook("scripts/items/supplies/food_item", function(q) {
// Hardened Functions
	q.HD_getShelfLifeMult = @(__original) function()
	{
		// The value now only drops once the shelf life is below half
		return ::Math.minf(1.0, this.getSpoilInDays() * 2.0 / this.m.GoodForDays);
	}
});
