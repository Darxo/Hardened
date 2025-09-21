::Hardened.HooksMod.hook("scripts/items/weapons/greatsword", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ChanceToHitHead = 10;	// Vanilla: 5

		this.m.Reach = 6;	// In Reforged this is 7
	}
});
