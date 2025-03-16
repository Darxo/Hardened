::Hardened.HooksMod.hook("scripts/items/weapons/two_handed_flail", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Reach = 4;		// In Reforged this is 5
	}
});
