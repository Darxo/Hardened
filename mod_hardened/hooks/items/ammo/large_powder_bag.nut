::Hardened.HooksMod.hook("scripts/items/ammo/large_powder_bag", function(q) {
	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
