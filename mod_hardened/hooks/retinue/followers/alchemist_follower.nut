::Hardened.HooksMod.hook("scripts/retinue/followers/alchemist_follower", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Cost = 3500;		// Vanilla: 2500
	}
});
