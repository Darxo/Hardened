::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_heavy_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.DirectDamageAdd = 0.1;	// Named versions of this weapon already have this bonus
	}
});

