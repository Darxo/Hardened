::Hardened.HooksMod.hook("scripts/skills/actives/adrenaline_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueCost = 15;	// In Reforged this is 10; In Vanilla this is 20
	}
});
