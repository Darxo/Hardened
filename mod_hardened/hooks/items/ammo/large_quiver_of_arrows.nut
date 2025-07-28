::Hardened.HooksMod.hook("scripts/items/ammo/large_quiver_of_arrows", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ID = "ammo.arrows_large";	// Vanilla Fix: Give a new unique ID, as the ID is no longer used to identify the ammo type
		this.m.AmmoWeight = 0.33;
	}

	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
