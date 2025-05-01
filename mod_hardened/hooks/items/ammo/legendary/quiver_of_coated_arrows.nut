::Hardened.HooksMod.hook("scripts/items/ammo/legendary/quiver_of_coated_arrows", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AmmoWeight = 0.2;
	}
});
