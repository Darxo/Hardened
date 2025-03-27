::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_cleaver", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Reach = 4;	// In Reforged this is 3
	}
});
