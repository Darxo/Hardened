::Hardened.HooksMod.hook("scripts/items/ammo/quiver_of_bolts", function(q) {
	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
