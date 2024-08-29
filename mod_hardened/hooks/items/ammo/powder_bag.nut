::Hardened.HooksMod.hook("scripts/items/ammo/powder_bag", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AmmoCost = 2;    // In Vanilla this is 1
		this.m.AmmoWeight = 0.4;
	}

	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
