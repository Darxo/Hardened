::Hardened.HooksMod.hook("scripts/items/weapons/flail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RegularDamage = 30;		// In Vanilla this is 25

		this.m.Reach = 3;		// In Reforged this is 4
	}
});
