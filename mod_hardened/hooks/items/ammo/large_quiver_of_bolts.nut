::Hardened.HooksMod.hook("scripts/items/ammo/large_quiver_of_bolts", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ID = "ammo.bolts_large";	// Vanilla Fix: Give a new unique ID, as the ID is no longer used to identify the ammo type
		this.m.AmmoWeight = 0.33;
	}

	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
