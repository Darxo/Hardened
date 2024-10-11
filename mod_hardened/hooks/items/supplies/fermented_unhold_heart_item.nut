::Hardened.HooksMod.hook("scripts/items/supplies/fermented_unhold_heart_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.GoodForDays = 40;	// In Vanilla this is 20
	}
});
