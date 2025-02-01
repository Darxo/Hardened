::Hardened.HooksMod.hook("scripts/items/weapons/greatsword", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Zweihander";
		this.m.Reach = 6;	// In Reforged this is 7
	}
});
