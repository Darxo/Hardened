::Hardened.HooksMod.hook("scripts/items/ammo/large_quiver_of_arrows", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AmmoWeight = 0.33;
	}

	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
