::Hardened.HooksMod.hook("scripts/items/ammo/powder_bag", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AmmoWeight = 0.4;
	}

	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
