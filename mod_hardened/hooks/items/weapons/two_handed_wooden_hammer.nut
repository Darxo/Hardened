::Hardened.HooksMod.hook("scripts/items/weapons/two_handed_wooden_hammer", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Reach = 5;		// In Reforged this is 4
	}
});
