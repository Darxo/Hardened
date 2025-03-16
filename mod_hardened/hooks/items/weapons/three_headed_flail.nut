::Hardened.HooksMod.hook("scripts/items/weapons/three_headed_flail", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Reach = 3;		// In Reforged this is 4
	}
});
