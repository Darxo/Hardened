::Hardened.HooksMod.hook("scripts/items/ammo/powder_bag", function(q) {
	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
