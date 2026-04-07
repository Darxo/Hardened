::Hardened.HooksMod.hook("scripts/items/special/trade_jug_02_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "A finely crafted jug, its surface lined with careful engravings. The liquid within gives off a faint sense of potency.";
	}
});
