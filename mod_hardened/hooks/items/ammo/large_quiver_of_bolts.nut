::Hardened.HooksMod.hook("scripts/items/ammo/large_quiver_of_bolts", function(q) {
	q.getTooltip = @() function()
	{
		return this.ammo.getTooltip();
	}
});
