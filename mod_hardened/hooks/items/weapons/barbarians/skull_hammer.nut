::Hardened.HooksMod.hook("scripts/items/weapons/barbarians/skull_hammer", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Reach = 5;		// In Reforged this is 4
	}
});
