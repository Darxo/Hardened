::Hardened.HooksMod.hook("scripts/items/ammo/large_powder_bag", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ID = "ammo.powder_large";	// Vanilla Fix: Give a new unique ID, as the ID is no longer used to identify the ammo type
		this.m.AmmoCost = 2;    // In Vanilla this is 1
		this.m.AmmoWeight = 0.5;
	}

	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
