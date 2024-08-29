::Hardened.HooksMod.hook("scripts/items/ammo/quiver_of_arrows", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AmmoWeight = 0.2;
	}

	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
