::Hardened.HooksMod.hook("scripts/items/shields/named/named_shield", function(q) {
	q.randomizeValues = @(__original) function()
	{
		if (this.m.BaseItemScript != null)
		{
			// In Hardened the vanilla shields no longer all have the same two skills. This way all named variants will mirror their base version
			// This adjustment even works after loading, because randomizeValues is always called for named items, just that its result is usually overwritten during deserialize
			this.onEquip = ::new(this.m.BaseItemScript).onEquip;
		}
		__original();
	}
});
