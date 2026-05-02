::Hardened.HooksMod.hook("scripts/items/weapons/military_cleaver", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Reach = 3;	// Reforged: 4
	}
});
