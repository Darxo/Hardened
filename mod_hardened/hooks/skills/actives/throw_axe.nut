::Hardened.HooksMod.hook("scripts/skills/actives/throw_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueCost = 15;	// In Vanilla this is 15; In Reforged this is 10
		this.m.MinRange = 1;	// In Vanilla this is 2
	}
});
